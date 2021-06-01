defmodule DeepThoughtWeb.EventController do
  use DeepThoughtWeb, :controller

  alias DeepThought.Slack
  alias DeepThought.Slack.{Event, LanguageConverter}

  action_fallback DeepThoughtWeb.FallbackController

  def create(conn, %{"type" => "url_verification"} = event_params) do
    with {:ok, %Event{} = event} <- Slack.create_event(event_params) do
      render(conn, "show.json", event: event)
    end
  end
end
