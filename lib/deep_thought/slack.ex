defmodule DeepThought.Slack do
  @moduledoc """
  The Slack context.
  """

  import Ecto.Query, warn: false
  alias DeepThought.Repo

  alias DeepThought.Slack.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(%{"type" => "url_verification"} = attrs) do
    %Event{}
    |> Event.url_verification_changeset(attrs)
    |> Repo.insert()
  end

  def transform_message_text([]), do: nil

  def transform_message_text([message | _]) do
    case Map.get(message, "text") do
      nil ->
        nil

      message ->
        message = Regex.replace(~r/<@\S+>/i, message, "👤")
        message = Regex.replace(~r/<!\S+>/i, message, "👥")
        message
    end
  end
end
