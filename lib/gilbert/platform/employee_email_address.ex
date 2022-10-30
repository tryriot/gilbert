defmodule Gilbert.Platform.EmployeeEmailAddress do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "employee_email_addresses" do
    field :address, :string
    field :is_primary, :boolean

    belongs_to :employee, Gilbert.Platform.Employee
    belongs_to :domain, Gilbert.Platform.Domain

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(workspace, attrs) do
    workspace
    |> cast(attrs, [:name, :status])
    |> validate_required([:name, :status])
  end
end
