defmodule BanKu.Repo.Migrations.AddConstraintAccountBalanceNotNegative do
  use Ecto.Migration

  def change do
    create constraint(:accounts, :balance_must_not_be_negative, check: "balance >= 0")
  end
end
