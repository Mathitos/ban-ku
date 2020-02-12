defmodule BanKuWeb.UserController do
  use BanKuWeb, :controller

  alias BanKu.Accounts
  alias BanKuWeb.JwtView

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn
        |> put_view(JwtView)
        |> render("jwt.json", jwt: token)

      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Login error"})
    end
  end
end
