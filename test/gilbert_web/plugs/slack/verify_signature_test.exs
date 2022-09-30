defmodule GilbertWeb.Plugs.Slack.VerifySignatureTest do
  use GilbertWeb.ConnCase, async: true

  test "init/1 raises when option :keys is not provided" do
    assert_raise ArgumentError, fn -> GilbertWeb.Plugs.Slack.VerifySignature.init([]) end
  end

  test "init/1 returns proper options" do
    opts = GilbertWeb.Plugs.Slack.VerifySignature.init(keys: [:private, :raw_body])

    assert opts === [keys: [:private, :raw_body], now: nil]
  end

  test "call/2 raises when the request timestamp is more than 5 minutes after the current time" do
    assert_raise GilbertWeb.Plugs.Slack.VerifySignature.RequestExpiredError, fn ->
      build_conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("x-slack-request-timestamp", "1664543944")
      |> GilbertWeb.Plugs.Slack.VerifySignature.call(now: DateTime.from_unix!(1_664_544_444))
    end
  end

  test "call/2 raises when the request signature is not equal to the computed signature" do
    assert_raise GilbertWeb.Plugs.Slack.VerifySignature.InvalidSignatureError, fn ->
      build_conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("x-slack-request-timestamp", "1664543944")
      |> put_req_header(
        "x-slack-signature",
        "v0=e5f3e34ea5e7d4aa00c1fae87e078c0965ebb6a0921b2dcf8d1cc05755c48328xxx"
      )
      |> put_private(:raw_body, [
        "payload=%7B%22type%22%3A%22shortcut%22%2C%22token%22%3A%22VWHclfHsdlfXmqBPWTG3K2Jp%22%2C%22action_ts%22%3A%221664543944.895023%22%2C%22team%22%3A%7B%22id%22%3A%22TQRJK2G8K%22%2C%22domain%22%3A%22tryriot%22%7D%2C%22user%22%3A%7B%22id%22%3A%22U01DLN4B5QT%22%2C%22username%22%3A%22pierre-yves%22%2C%22team_id%22%3A%22TQRJK2G8K%22%7D%2C%22is_enterprise_install%22%3Afalse%2C%22enterprise%22%3Anull%2C%22callback_id%22%3A%22request_support%22%2C%22trigger_id%22%3A%224170051523169.841631084291.20b891e79031776630771cbc27bb0eb0%22%7D"
      ])
      |> GilbertWeb.Plugs.Slack.VerifySignature.call(
        keys: [:private, :raw_body],
        now: DateTime.from_unix!(1_664_543_948)
      )
    end
  end

  test "call/2 does not raise when the request signature is equal to the computed signature" do
    build_conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("x-slack-request-timestamp", "1664543944")
    |> put_req_header(
      "x-slack-signature",
      "v0=e5f3e34ea5e7d4aa00c1fae87e078c0965ebb6a0921b2dcf8d1cc05755c48328"
    )
    |> put_private(:raw_body, [
      "payload=%7B%22type%22%3A%22shortcut%22%2C%22token%22%3A%22VWHclfHsdlfXmqBPWTG3K2Jp%22%2C%22action_ts%22%3A%221664543944.895023%22%2C%22team%22%3A%7B%22id%22%3A%22TQRJK2G8K%22%2C%22domain%22%3A%22tryriot%22%7D%2C%22user%22%3A%7B%22id%22%3A%22U01DLN4B5QT%22%2C%22username%22%3A%22pierre-yves%22%2C%22team_id%22%3A%22TQRJK2G8K%22%7D%2C%22is_enterprise_install%22%3Afalse%2C%22enterprise%22%3Anull%2C%22callback_id%22%3A%22request_support%22%2C%22trigger_id%22%3A%224170051523169.841631084291.20b891e79031776630771cbc27bb0eb0%22%7D"
    ])
    |> GilbertWeb.Plugs.Slack.VerifySignature.call(
      keys: [:private, :raw_body],
      now: DateTime.from_unix!(1_664_543_948)
    )
  end
end
