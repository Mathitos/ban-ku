defmodule BanKu.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @initial_balance 100_000

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :balance, :integer
    field :owner_name, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:owner_name, :balance])
    |> validate_required([:owner_name, :balance])
  end

  def get_initial_value() do
    @initial_balance
  end
end
