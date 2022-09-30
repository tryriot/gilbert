defmodule GilbertWeb.Plugs.Slack.DecodePayload do
  alias Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    payload =
      conn.body_params["payload"]
      |> Jason.decode!()

    Conn.assign(conn, :slack_payload, payload)
  end
end
