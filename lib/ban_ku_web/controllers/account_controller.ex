defmodule BanKuWeb.AccountController do
  use BanKuWeb, :controller

  alias BanKu.Accounts
  alias BanKu.Accounts.Account

  action_fallback BanKuWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, "index.json", accounts: accounts)
  end

  def create(conn, %{"owner_name" => owner_name, "email" => email}) do
    with {:ok, %Account{} = account} <-
           Accounts.create_account(%{owner_name: owner_name, email: email}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.account_path(conn, :show, account))
      |> render("show.json", account: account)
    end
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, "show.json", account: account)
  end
end
