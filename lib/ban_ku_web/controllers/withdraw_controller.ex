defmodule BanKuWeb.WithdrawController do
  use BanKuWeb, :controller
  alias BanKu.Accounts
  alias BanKuWeb.{AccountView, ErrorView}

  def withdraw(conn, %{"account_id" => account_id, "amount" => amount}) do
    user = conn.assigns.user

    case Accounts.withdraw_from_account(user.id, account_id, amount) do
      {:ok, account} ->
        conn
        |> put_view(AccountView)
        |> render("show.json", account: account)

      _ ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render(:"400")
    end
  end

  def withdraw(conn, _) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> render(:"422")
  end
end
