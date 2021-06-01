defmodule DeepThoughtWeb.ActionController do
  use DeepThoughtWeb, :controller

  alias DeepThought.Slack

  action_fallback(DeepThoughtWeb.FallbackController)

  def create(conn, %{"payload" => payload}) do
    with %{
           "actions" => [%{"selected_option" => %{"value" => "delete"}}],
           "container" => %{
             "channel_id" => channel_id,
             "message_ts" => message_ts,
             "thread_ts" => thread_ts
           },
           "user" => %{"id" => user_id}
         } <- Jason.decode!(payload),
         :ok <- Slack.API.chat_delete(channel_id, message_ts),
         :ok <-
           Slack.API.chat_post_ephemeral(
             channel_id,
             user_id,
             "I deleted the translation.",
             thread_ts
           ) do
      send_resp(conn, :ok, "")
    else
      _ -> send_resp(conn, :internal_server_error, "")
    end
  end
end
