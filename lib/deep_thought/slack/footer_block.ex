defmodule DeepThought.Slack.FooterBlock do
  alias DeepThought.Slack

  def generate(%{"user" => userId}, original_text) do
    abbreviated_text(original_text)
    |> append_username(userId)
    |> block_content()
  end

  defp abbreviated_text(original_text) do
    case String.length(original_text) do
      x when x in 0..49 -> original_text
      _ -> String.slice(original_text, 0..48) <> "…"
    end
  end

  defp append_username(abbreviated_text, userId) do
    case Slack.API.users_profile_get(userId) do
      {:ok, %{"real_name" => real_name}} ->
        abbreviated_text <> "\nOriginally sent by: " <> real_name

      _ ->
        abbreviated_text
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
