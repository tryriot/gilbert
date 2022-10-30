defmodule Gilbert.Platform.Workspace.Helpers do
  alias Gilbert.Platform.Workspace
  import Ecto.Query

  def list_all_with_active_employees_count(search) do
    uuid_info = UUID.info(search)

    base_query =
      from w in Workspace,
        left_join: e in assoc(w, :employees),
        on: e.status == ^"active",
        group_by: w.id,
        select: {w, count(e.id)}

    base_query
    |> maybe_add_id_condition(uuid_info)
    |> maybe_add_name_search(uuid_info, search)
  end

  defp maybe_add_name_search(query, {:error, _}, search) do
    query |> or_where([w], ilike(w.name, ^"%#{search}%"))
  end

  defp maybe_add_name_search(query, _, _), do: query

  defp maybe_add_id_condition(query, {:ok, uuid_info}) do
    query |> or_where([w], w.id == ^uuid_info[:uuid])
  end

  defp maybe_add_id_condition(query, {:error, _}), do: query
end
