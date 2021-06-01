defmodule DeepThought.Slack.FooterBlock do
  def generate(original_text) do
    abbreviated_text(original_text)
    |> block_content()
  end

  defp abbreviated_text(original_text) do
    case String.length(original_text) do
      x when x in 0..49 -> original_text
      _ -> String.slice(original_text, 0..48) <> "…"
    end
  end

  defp block_content(footer_text) do
    %{
      "type" => "context",
      "elements" => [
        %{
          "type" => "mrkdwn",
          "text" => footer_text
        }
      ]
    }
  end
end
