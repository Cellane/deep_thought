defmodule DeepThought.Slack.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :type, :string, null: false
    field :challenge, :string

    timestamps()
  end

  @doc false
  def url_verification_changeset(event, attrs) do
    event
    |> cast(attrs, [:type, :challenge])
    |> validate_required([:type, :challenge])
  end
end
