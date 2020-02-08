defmodule BanKu.Repo do
  use Ecto.Repo,
    otp_app: :ban_ku,
    adapter: Ecto.Adapters.Postgres
end
