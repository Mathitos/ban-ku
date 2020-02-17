defmodule BanKuWeb.AccountView do
  use BanKuWeb, :view
  alias BanKuWeb.AccountView

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      owner_name: account.owner_name,
      email: account.email,
      balance: account.balance
    }
  end
end
