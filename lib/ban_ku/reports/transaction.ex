defmodule BanKu.Reports.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :account_dest_id, :binary
    field :account_origin_id, :binary
    field :amount, :integer
    field :date, :utc_datetime
    field :operator_id, :binary

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:operator_id, :date, :amount, :account_origin_id, :account_dest_id])
    |> validate_required([:operator_id, :date, :amount, :account_origin_id, :account_dest_id])
  end
end
