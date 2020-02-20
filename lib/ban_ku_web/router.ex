defmodule BanKuWeb.Router do
  use BanKuWeb, :router

  alias BanKuWeb.Guardian.AuthPipeline

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug AuthPipeline
  end

  scope "/api/v1", BanKuWeb do
    pipe_through([:api, :auth])

    resources("/accounts", AccountController, only: [:create, :index, :show])
    post("/withdraw", WithdrawController, :withdraw)
    get("/transactions", TransactionController, :index)
    get("/report", TransactionController, :report)
  end

  scope "/api/v1", BanKuWeb do
    pipe_through(:api)
    post "/sign_in", UserController, :sign_in
  end
end
