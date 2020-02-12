import Config

config :ban_ku, BanKuWeb.Endpoint, server: true

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :ban_ku, BanKuWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

database_name =
  System.get_env("DATABASE_NAME") ||
    raise """
    environment variable DATABASE_NAME is missing.
    """

database_username =
  System.get_env("DATABASE_USERNAME") ||
    raise """
    environment variable DATABASE_USERNAME is missing.
    """

database_password =
  System.get_env("DATABASE_PASSWORD") ||
    raise """
    environment variable DATABASE_PASSWORD is missing.
    """

config :ban_ku, BanKu.Repo,
  username: database_username,
  password: database_password,
  database: database_name,
  ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

guardian_secret_key =
  System.get_env("GUARDIAN_SECRET_KEY") ||
    raise """
    environment variable GUARDIAN_SECRET_KEY is missing.
    """

config :ban_ku, BanKuWeb.Guardian,
  issuer: "BanKu",
  secret_key: guardian_secret_key
