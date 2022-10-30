defmodule Gilbert.Platform.Domain do
  use Ecto.Schema
  import Ecto.Changeset

  @type provider :: :Google | :Microsoft | :unknown
  @type status :: :unsupported | :unverified | :pending | :verified
  @type sending_method :: :GmailApi | :OutlookApi | :IpWhitelist
  @type t :: %__MODULE__{
          name: String.t(),
          provider: provider(),
          status: status(),
          source: String.t(),
          sending_method: sending_method()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "domains" do
    field :name, :string
    field :provider, Ecto.Enum, values: [:Google, :Microsoft, :unknown]
    field :status, Ecto.Enum, values: [:unsupported, :unverified, :pending, :verified]
    field :source, :string
    field :sending_method, Ecto.Enum, values: [:GmailApi, :OutlookApi, :IpWhitelist]

    belongs_to :workspace, Gilbert.Platform.Workspace

    has_many :employee_email_addresses, Gilbert.Platform.EmployeeEmailAddress

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(workspace, attrs) do
    workspace
    |> cast(attrs, [:name, :logo_url])
    |> validate_required([:name])
  end
end
