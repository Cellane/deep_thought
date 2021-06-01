defmodule DeepThought.Slack.TranslationBlock do
  def generate(translated_text) do
    block_content(translated_text)
  end

  defp block_content(translated_text) do
    %{
      "type" => "section",
      "text" => %{
        "type" => "mrkdwn",
        "text" => translated_text
      }
    }
  end
end
