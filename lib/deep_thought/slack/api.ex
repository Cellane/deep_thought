defmodule DeepThought.Slack.API do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://slack.com/api")

  plug(Tesla.Middleware.Headers, [
    {"Authorization", "Bearer " <> Application.get_env(:deep_thought, :slack)[:bot_token]}
  ])

  plug(Tesla.Middleware.JSON)

  def conversations_replies(channel, ts) do
    case get("/conversations.replies", query: [channel: channel, ts: ts, inclusive: true]) do
      {:ok, response} -> {:ok, response.body() |> Map.get("messages")}
      {:error, error} -> {:error, error}
    end
  end

  def post_message(channel, text) do
    case post("/chat.postMessage", %{channel: channel, text: text}) do
      {:ok, response} -> :ok
      {:error, error} -> {:error, error}
    end
  end
end
