defmodule GilbertWeb.Plugs.Slack.VerifySignature do
  defmodule InvalidSignatureError do
    @moduledoc """
    Error raised when the request signature is invalid.
    """

    defexception message: "invalid request signature", plug_status: 400
  end

  defmodule RequestExpiredError do
    @moduledoc """
    Error raised when the request timestamp is older than the maximum allowed request delay.
    """

    defexception message: "request expired", plug_status: 400
  end

  alias Plug.Conn

  @behaviour Plug

  @impl true
  @spec init(keyword) :: keyword
  def init(opts) do
    {keys, _} = Keyword.pop(opts, :keys)

    unless keys do
      raise ArgumentError,
            "GilbertWeb.Plugs.Slack.VerifySignature expects a set of keys to be given in :keys. These keys will be used with the `Kernel.get_in/2` function to retrieve the raw body from the `Plug.Conn` struct"
    end

    Keyword.new([{:keys, keys}, {:now, nil}])
  end

  @impl true
  @spec call(Plug.Conn.t(), keyword) :: Plug.Conn.t()
  def call(conn, opts) do
    now = Keyword.get(opts, :now, DateTime.now!("Etc/UTC"))

    [request_timestamp | _] = Conn.get_req_header(conn, "x-slack-request-timestamp")

    {:ok, request_sent_at} = DateTime.from_unix(String.to_integer(request_timestamp))

    date_diff = DateTime.diff(now, request_sent_at, :minute)

    if date_diff > 5 do
      raise RequestExpiredError
    end

    [request_body | _] =
      get_in(conn, Enum.map(Keyword.get(opts, :keys), fn key -> Access.key!(key) end))

    {:ok, slack_config} = Application.fetch_env(:gilbert, :slack)

    signature =
      hmac256(request_timestamp, request_body, Keyword.get(slack_config, :signing_secret))

    [request_signature | _] = Conn.get_req_header(conn, "x-slack-signature")

    unless request_signature === signature do
      raise InvalidSignatureError
    end

    conn
  end

  defp hmac256(request_timestamp, request_body, signing_secret) do
    hmac256 =
      :crypto.mac(:hmac, :sha256, signing_secret, "v0:#{request_timestamp}:#{request_body}")
      |> Base.encode16(case: :lower)

    "v0=" <> hmac256
  end
end
