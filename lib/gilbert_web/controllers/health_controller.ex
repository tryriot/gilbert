defmodule GilbertWeb.Health.Controller do
  use GilbertWeb, :controller

  def index(conn, _params) do
    json(conn, %{})
  end
end
