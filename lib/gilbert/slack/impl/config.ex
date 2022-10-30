defmodule Gilbert.Slack.Impl.Config do
  def support_channel do
    slack_env = Application.get_env(:gilbert, :slack)

    slack_env[:support_channel]
  end
end
