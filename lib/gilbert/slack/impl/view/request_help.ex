defmodule Gilbert.Slack.Impl.View.RequestHelp do
  def build do
    BlockBox.Views.build_view(
      :modal,
      "Request help",
      [
        BlockBox.LayoutBlocks.input(
          "Workspace",
          BlockBox.BlockElements.select_menu(
            "Paste a workspace ID or type to search for a workspace",
            :external_select,
            "workspace_choice"
          ),
          hint: "Leave blank if you are asking a general question not related to any workspace.",
          optional: true
        ),
        BlockBox.LayoutBlocks.input(
          "Description",
          BlockBox.BlockElements.plain_text_input("issue_description",
            placeholder: "Please describe the problem or the question as clearly as possible.",
            multiline: true
          )
        ),
        BlockBox.LayoutBlocks.context_block([
          BlockBox.CompositionObjects.text_object(
            "Clicking 'Submit' will post a message in \##{Gilbert.Slack.Impl.Config.support_channel()} for you. It will contain the text you entered along with information about the workspace you selected. If you want to add screenshots or links, please add them as a thread after the message is posted."
          )
        ])
      ],
      submit: "Submit 🚀",
      close: "Cancel 😳",
      callback_id: "request_help"
    )
  end
end
