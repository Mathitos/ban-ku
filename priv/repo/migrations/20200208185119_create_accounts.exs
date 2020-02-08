defmodule BanKu.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :owner_name, :string
      add :balance, :integer

      timestamps()
    end

  end
end
