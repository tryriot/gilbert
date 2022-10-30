defmodule Gilbert.Slack.Impl.Message.RequestHelp do
  alias Gilbert.Platform.Workspace.MiniProfile

  def compose(user, description, mini_profile) do
    ([
       BlockBox.LayoutBlocks.section(
         BlockBox.CompositionObjects.text_object(
           "<@#{user["id"]}> is requesting some help:",
           :mrkdwn
         )
       ),
       BlockBox.LayoutBlocks.section(
         BlockBox.CompositionObjects.text_object(description, :mrkdwn)
       )
     ] ++ maybe_add_request_help_context(mini_profile))
    |> Jason.encode!()
  end

  @spec maybe_add_request_help_context(MiniProfile.t() | nil) :: list()

  defp maybe_add_request_help_context(nil), do: []

  defp maybe_add_request_help_context(mini_profile = %MiniProfile{}) do
    [
      BlockBox.LayoutBlocks.divider(),
      BlockBox.LayoutBlocks.context_block(
        [
          BlockBox.BlockElements.image(
            mini_profile.workspace.logo_url ||
              URI.encode("https://eu.ui-avatars.com/api/?name=#{mini_profile.workspace.name}"),
            "Logo of workspace #{mini_profile.workspace.name}"
          ),
          BlockBox.CompositionObjects.text_object(
            "#{mini_profile.workspace.name} (#{mini_profile.workspace.id})"
          ),
          if(mini_profile.workspace.stripe_subscription_id,
            do: BlockBox.CompositionObjects.text_object("💳"),
            else: nil
          ),
          BlockBox.CompositionObjects.text_object("👤 #{mini_profile.active_employees_count}")
        ]
        |> Enum.reject(&is_nil/1)
      ),
      BlockBox.LayoutBlocks.context_block([
        BlockBox.CompositionObjects.text_object(mini_profile.top_domain.name),
        BlockBox.CompositionObjects.text_object(
          "verification: #{Atom.to_string(mini_profile.top_domain.status)}"
        ),
        BlockBox.CompositionObjects.text_object(Atom.to_string(mini_profile.top_domain.provider)),
        BlockBox.CompositionObjects.text_object(
          Atom.to_string(mini_profile.top_domain.sending_method)
        )
      ])
    ]
  end
end
