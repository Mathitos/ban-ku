defmodule BanKuWeb.Router do
  use BanKuWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
  end

  scope "/api/v1", BanKuWeb do
    pipe_through(:api)
    pipe_through(:auth)

    resources("/accounts", AccountController, only: [:create, :index, :show])
    post("/withdraw", WithdrawController, :withdraw)
  end

  scope "/api/v1", BanKuWeb do
    pipe_through(:api)
    post "/sign_in", UserController, :sign_in
  end
end
