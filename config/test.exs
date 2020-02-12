use Mix.Config

# Configure your database
config :ban_ku, BanKu.Repo,
  username: "postgres",
  password: "postgres",
  database: "ban_ku_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ban_ku, BanKuWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :ban_ku, BanKuWeb.Guardian,
  issuer: "BanKu",
  secret_key: "kLgBLxgjSVO6Gq8+U/xmpTZj3h52wxzyfMvwoDISF/KKYvu5W1vxRrzi4KoJbSO0"
