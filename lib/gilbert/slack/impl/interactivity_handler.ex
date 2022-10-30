defmodule Gilbert.Slack.Impl.InteractivityHandler do
  def handle(
        %{
          "type" => "view_submission",
          "view" => %{"callback_id" => callback_id, "state" => state}
        } = payload
      ),
      do: handle_view_submission(callback_id, state, payload)

  def handle(
        %{
          "type" => "shortcut"
        } = payload
      ) do
    handle_shortcut(payload)
  end

  def handle(
        %{
          "type" => "block_actions",
          "actions" => actions
        } = payload
      ) do
    handle_block_actions(actions, payload)
  end

  defp handle_view_submission("request_help", state, payload) do
    values = BlockBox.get_submission_values(state["values"])
    workspace_id = values["workspace_choice"]
    description = values["issue_description"]

    %{"ok" => true, "user" => user} = Slack.Web.Users.info(payload["user"]["id"])

    support_channel = Gilbert.Slack.Impl.Config.support_channel()

    mini_profile = Gilbert.Platform.Workspace.MiniProfile.slack(workspace_id)

    Slack.Web.Chat.post_message(
      support_channel,
      "#{user["real_name"]} is requesting some help in #{support_channel}",
      %{
        blocks: Gilbert.Slack.Impl.Message.RequestHelp.compose(user, description, mini_profile)
      }
    )

    {:reply,
     %{
       "response_action" => "clear"
     }}
  end

  defp handle_block_actions(
         [
           %{"action_id" => "workspace_choice"} | _
         ],
         %{"view" => %{"callback_id" => "request_help"}}
       ),
       do: :ok

  defp handle_shortcut(%{"callback_id" => "request_support", "trigger_id" => trigger_id}) do
    open_view(trigger_id, Gilbert.Slack.Impl.View.RequestHelp)

    :noreply
  end

  defp update_view(view_id, view) do
    token = get_bot_user_oauth_token()
    view = apply(view, :build, []) |> Jason.encode!()

    Slack.Web.Views.update(token, view, %{view_id: view_id})
  end

  defp open_view(trigger_id, view) do
    token = get_bot_user_oauth_token()
    view = apply(view, :build, []) |> Jason.encode!()

    Slack.Web.Views.open(token, trigger_id, view)
  end

  defp get_bot_user_oauth_token do
    slack_config = Application.fetch_env!(:gilbert, :slack)

    Keyword.get(slack_config, :bot_user_oauth_token)
  end
end
