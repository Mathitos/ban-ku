defmodule BanKuWeb.TransferController do
  use BanKuWeb, :controller
  alias BanKu.Accounts
  alias BanKuWeb.{TransactionView, ErrorView}

  def transfer(conn, %{
        "account_origin_id" => account_origin_id,
        "account_dest_id" => account_dest_id,
        "amount" => amount
      }) do
    user = conn.assigns.user

    case Accounts.transfer_from_accounts(user.id, account_origin_id, account_dest_id, amount) do
      {:ok, transaction} ->
        conn
        |> put_view(TransactionView)
        |> render("show.json", transaction: transaction)

      _ ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render(:"400")
    end
  end

  def transfer(conn, _) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> render(:"422")
  end
end
