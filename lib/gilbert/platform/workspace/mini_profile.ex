defmodule Gilbert.Platform.Workspace.MiniProfile do
  alias Gilbert.Platform.{Workspace, Domain, Repo}
  import Ecto.Query

  @type t :: %__MODULE__{
          workspace: Workspace.t(),
          active_employees_count: integer(),
          top_domain: Domain.t() | nil
        }

  defstruct workspace: nil, active_employees_count: nil, top_domain: nil

  @spec slack(String.t() | nil) :: t() | nil
  def slack(nil), do: nil

  def slack(workspace_id) do
    top_domain_query =
      from d in Domain,
        left_join: e in assoc(d, :employee_email_addresses),
        on: e.is_primary == ^true,
        where: d.workspace_id == ^workspace_id,
        group_by: d.id,
        order_by: fragment("email_address_count DESC"),
        limit: 1,
        select: {d, fragment("count(?) as email_address_count", e.id)}

    {top_domain, _} = Repo.one(top_domain_query)

    workspace_query =
      from w in Workspace,
        left_join: e in assoc(w, :employees),
        on: e.status == ^"active",
        where: w.id == ^workspace_id,
        group_by: w.id,
        limit: 1,
        select: {w, count(e.id)}

    {workspace, active_employees_count} = Repo.one(workspace_query)

    %__MODULE__{
      workspace: workspace,
      active_employees_count: active_employees_count,
      top_domain: top_domain
    }
  end
end
