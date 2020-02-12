defmodule BanKuWeb.JwtView do
  use BanKuWeb, :view

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
