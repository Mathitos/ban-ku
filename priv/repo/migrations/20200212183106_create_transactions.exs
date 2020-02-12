defmodule BanKu.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :operator_id, :binary
      add :date, :utc_datetime
      add :amount, :integer
      add :account_origin_id, :binary
      add :account_dest_id, :binary

      timestamps()
    end

  end
end
