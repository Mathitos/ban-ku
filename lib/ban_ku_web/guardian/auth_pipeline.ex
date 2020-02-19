defmodule BanKuWeb.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :ban_ku,
    module: BanKuWeb.Guardian,
    error_handler: BanKuWeb.Guardian.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
  plug BanKuWeb.Plugs.SetUserPlug
end
