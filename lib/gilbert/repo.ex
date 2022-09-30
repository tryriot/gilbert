defmodule Gilbert.Repo do
  use Ecto.Repo,
    otp_app: :gilbert,
    adapter: Ecto.Adapters.Postgres
end
