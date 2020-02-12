defmodule BanKuWeb.TransactionView do
  use BanKuWeb, :view
  alias BanKuWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{id: transaction.id,
      operator_id: transaction.operator_id,
      date: transaction.date,
      amount: transaction.amount,
      account_origin_id: transaction.account_origin_id,
      account_dest_id: transaction.account_dest_id}
  end
end
