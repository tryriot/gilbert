defmodule GilbertWeb.Slack.InteractivityController do
  use GilbertWeb, :controller

  def index(conn, _params) do
    conn |> send_response(Gilbert.Slack.handle_interactivity(conn.assigns[:slack_payload]))
  end

  def options_load(conn, _params) do
    conn |> send_response(Gilbert.Slack.handle_options_load(conn.assigns[:slack_payload]))
  end

  defp send_response(conn, :noreply), do: send_resp(conn, 204, "")
  defp send_response(conn, {:reply, payload}), do: json(conn, payload)
end
