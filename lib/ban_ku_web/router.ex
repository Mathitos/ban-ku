defmodule BanKuWeb.Router do
  use BanKuWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BanKuWeb do
    pipe_through :api
  end
end
