defmodule BanKuWeb.TransactionController do
  use BanKuWeb, :controller

  alias BanKu.Reports
  alias BanKu.Reports.Transaction

  action_fallback BanKuWeb.FallbackController

  def index(conn, _params) do
    transactions = Reports.list_transactions()
    render(conn, "index.json", transactions: transactions)
  end

  def report(conn, _params) do
    json(conn, Reports.gen_report())
  end
end
