defmodule DeepThoughtWeb.EventController do
  use DeepThoughtWeb, :controller

  alias DeepThought.DeepL
  alias DeepThought.Slack
  alias DeepThought.Slack.{Event, LanguageConverter}

  action_fallback(DeepThoughtWeb.FallbackController)

  def create(conn, %{"type" => "url_verification"} = event_params) do
    with {:ok, %Event{} = event} <- Slack.create_event(event_params) do
      render(conn, "show.json", event: event)
    end
  end

  def create(
        conn,
        %{
          "event" =>
            %{
              "item" => %{"channel" => channelId, "ts" => messageTs, "type" => "message"},
              "reaction" => reaction,
              "type" => "reaction_added"
            } = event_details,
          "type" => "event_callback"
        } = event_params
      ) do
    with {:ok, language} <- LanguageConverter.reaction_to_lang(reaction),
         {:ok, [message | _]} <- Slack.API.conversations_replies(channelId, messageTs),
         messageText when not is_nil(messageText) <- Slack.transform_message_text(message),
         {:ok, translation} <- DeepL.API.translate(messageText, language),
         :ok <- Slack.say_in_thread(channelId, translation, message, messageText) do
      send_resp(conn, :no_content, "")
    else
      _ ->
        send_resp(conn, :internal_server_error, "")
    end
  end
end
