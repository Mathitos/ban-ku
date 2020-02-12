defmodule BanKu.Repo.Migrations.AddUserTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, unique: true
      add :password_hash, :string

      timestamps()
    end
  end
end
