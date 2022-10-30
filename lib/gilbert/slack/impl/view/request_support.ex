defmodule Gilbert.Slack.Impl.View.RequestSupport do
  def build do
    BlockBox.Views.build_view(:modal, "Request support", [
      %{
        "type" => "header",
        "text" => BlockBox.CompositionObjects.text_object("What kind of help do you need?")
      },
      BlockBox.LayoutBlocks.input(
        "What kind of help do you need?",
        BlockBox.BlockElements.radio_buttons(
          "request_support_choice",
          [
            BlockBox.CompositionObjects.option_object(
              "I need to validate a domain",
              "validate_domain"
            ),
            BlockBox.CompositionObjects.option_object(
              "I need help from the tech team",
              "request_help"
            )
          ]
        ),
        dispatch_action: true
      )
    ])
  end
end
