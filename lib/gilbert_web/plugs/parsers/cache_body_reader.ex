defmodule GilbertWeb.Plugs.Parsers.CacheBodyReader do
  alias Plug.Conn

  def read_body(conn, opts) do
    {:ok, body, conn} = Conn.read_body(conn, opts)
    conn = update_in(conn.private[:raw_body], &[body | &1 || []])

    {:ok, body, conn}
  end
end
