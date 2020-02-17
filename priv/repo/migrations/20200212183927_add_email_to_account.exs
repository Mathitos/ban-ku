defmodule BanKu.Repo.Migrations.AddEmailToAccount do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :email, :string, unique: true
    end
  end
end
