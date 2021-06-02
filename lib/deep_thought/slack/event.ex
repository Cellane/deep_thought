defmodule DeepThought.Slack.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field(:type, :string, null: false)
    field(:challenge, :string)
    field(:target_language, :string)
    field(:channel_id, :string)
    field(:message_ts, :string)

    timestamps()
  end

  @doc false
  def url_verification_changeset(event, attrs) do
    event
    |> cast(attrs, [:type, :challenge])
    |> validate_required([:type, :challenge])
  end

  def reaction_added_changeset(event, attrs) do
    event
    |> cast(attrs, [:type, :target_language, :channel_id, :message_ts])
    |> validate_required([:type, :target_language, :channel_id, :message_ts])
  end
end
