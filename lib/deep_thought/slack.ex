defmodule DeepThought.Slack do
  @moduledoc """
  The Slack context.
  """

  import Ecto.Query, warn: false
  alias DeepThought.Repo

  alias DeepThought.Slack
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

  def transform_message_text(message) do
    messageText = Map.get(message, "text")
    messageText = Regex.replace(~r/<@\S+>/i, messageText, "👤")
    messageText = Regex.replace(~r/<!\S+>/i, messageText, "👥")
    messageText
  end

  def say_in_thread(channel_id, text, message, original_text) do
    blocks =
      [
        Slack.TranslationBlock.generate(text),
        Slack.FooterBlock.generate(message, channel_id, original_text)
      ]
      |> Jason.encode!()

    Slack.API.chat_post_message(channel_id, text,
      blocks: blocks,
      thread_ts: get_thread_ts(message)
    )
  end

  defp get_thread_ts(%{"thread_ts" => thread_ts}), do: thread_ts
  defp get_thread_ts(%{"ts" => ts}), do: ts
end
