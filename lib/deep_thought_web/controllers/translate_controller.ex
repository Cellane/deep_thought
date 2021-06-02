defmodule DeepThoughtWeb.TranslateController do
  use DeepThoughtWeb, :controller

  alias DeepThought.DeepL
  alias DeepThought.Slack
  alias DeepThought.Slack.LanguageConverter

  action_fallback(DeepThoughtWeb.FallbackController)

  def create(conn, %{"channel_id" => channel_id, "text" => text, "user_name" => username}) do
    DeepThought.TranslatorSupervisor.simple_translate(channel_id, text, username)

    send_resp(conn, :ok, "")
  end

  defp generate_message(translation, original_message, username) do
    "_@" <>
      username <>
      " asked me to translate this:_ " <>
      translation <> "\n_The original message was:_ " <> original_message
  end
end
