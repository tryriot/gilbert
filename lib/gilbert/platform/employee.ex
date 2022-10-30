defmodule Gilbert.Platform.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "employees" do
    field :name, :string
    field :status, :string

    belongs_to :workspace, Gilbert.Platform.Workspace

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(workspace, attrs) do
    workspace
    |> cast(attrs, [:name, :status])
    |> validate_required([:name, :status])
  end
end
