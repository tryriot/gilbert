defmodule Gilbert.Platform.Workspace do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t(),
          logo_url: String.t() | nil,
          stripe_customer_id: String.t() | nil,
          stripe_subscription_id: String.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "workspaces" do
    field :name, :string
    field :logo_url, :string, source: :profile_url
    field :stripe_customer_id, :string
    field :stripe_subscription_id, :string

    has_many :domains, Gilbert.Platform.Domain
    has_many :employees, Gilbert.Platform.Employee

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(workspace, attrs) do
    workspace
    |> cast(attrs, [:name, :logo_url])
    |> validate_required([:name])
  end
end
