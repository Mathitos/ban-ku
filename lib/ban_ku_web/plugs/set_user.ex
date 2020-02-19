defmodule BanKuWeb.Plugs.SetUserPlug do
  import Plug.Conn

  def init(_params), do: nil

  def call(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> assign(:user, user)
  end
end
