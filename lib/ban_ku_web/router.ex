defmodule BanKuWeb.Router do
  use BanKuWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
  end

  scope "/api", BanKuWeb do
    pipe_through(:api)
    pipe_through(:auth)

    resources("/accounts", AccountController, only: [:index, :show])
  end

  scope "/api", BanKuWeb do
    pipe_through(:api)

    resources("/accounts", AccountController, only: [:create])
  end
end
