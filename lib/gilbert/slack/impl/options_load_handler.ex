defmodule Gilbert.Slack.Impl.OptionsLoadHandler do
  alias Gilbert.Platform.Repo

  def handle(%{
        "action_id" => "workspace_choice",
        "value" => search
      }) do
    workspaces =
      Repo.all(Gilbert.Platform.Workspace.Helpers.list_all_with_active_employees_count(search),
        limit: 20
      )

    {:reply,
     %{
       "options" =>
         Enum.map(workspaces, fn {workspace, active_employee_count} ->
           %{
             "text" =>
               BlockBox.CompositionObjects.text_object(
                 "#{workspace.name}    👤 #{active_employee_count}    #{if workspace.stripe_subscription_id, do: "💳", else: ""}"
               ),
             "value" => workspace.id
           }
         end)
     }}
  end
end
