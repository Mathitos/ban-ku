defmodule BanKu.Repo.Migrations.MakeEmailFieldUnique do
  use Ecto.Migration

  def change do
    create unique_index(:accounts, [:email])
  end
end
