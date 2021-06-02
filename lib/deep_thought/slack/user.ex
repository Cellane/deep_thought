defmodule DeepThought.Slack.User do
  use Ecto.Schema

  alias DeepThought.Slack.User
  import Ecto.Changeset
  import Ecto.Query

  schema "slack_users" do
    field(:user_id, :string)
    field(:real_name, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id, :real_name])
    |> validate_required([:user_id, :real_name])
  end

  def with_user_ids(user_ids) do
    from(u in User,
      where: u.user_id in ^user_ids,
      select: %{user_id: u.user_id, real_name: u.real_name}
    )
  end
end
