defmodule Gilbert.Slack do
  defdelegate handle_interactivity(payload),
    to: Gilbert.Slack.Impl.InteractivityHandler,
    as: :handle

  defdelegate handle_options_load(payload),
    to: Gilbert.Slack.Impl.OptionsLoadHandler,
    as: :handle
end
