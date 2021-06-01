defmodule DeepThoughtWeb.EventView do
  use DeepThoughtWeb, :view
  alias DeepThoughtWeb.EventView

  def render("show.json", %{event: event}) do
    %{challenge: event.challenge}
  end
end
