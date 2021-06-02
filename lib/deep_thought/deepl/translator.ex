defmodule DeepThought.DeepL.Translator do
  alias DeepThought.DeepL
  alias DeepThought.Slack
  alias DeepThought.Slack.LanguageConverter

  def translate(event_details, reaction, channel_id, message_ts) do
    {:ok, language} = LanguageConverter.reaction_to_lang(reaction)

    unless Slack.recently_translated?(channel_id, message_ts, language) do
      {:ok, [message | _]} = Slack.API.conversations_replies(channel_id, message_ts)

      case escape_message_text(message) do
        messageText ->
          {:ok, translation} = DeepL.API.translate(messageText, language)
          :ok = Slack.say_in_thread(channel_id, translation, message, messageText)
          params = create_translation_event_params(event_details, language)
          Slack.create_event(params)

        _ ->
          nil
      end
    end
  end

  def escape_message_text(message) do
    messageText = Map.get(message, "text")

    Regex.replace(~r/<([@!]\S+)>/i, messageText, fn _, username ->
      "<username>&lt;" <> username <> "&gt;</username>"
    end)
  end

  defp create_translation_event_params(
         %{"item" => %{"channel" => channel_id, "ts" => message_ts}, "type" => type},
         language
       ) do
    %{
      "type" => type,
      "target_language" => language,
      "channel_id" => channel_id,
      "message_ts" => message_ts
    }
  end
end
