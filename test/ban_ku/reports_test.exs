defmodule BanKu.ReportsTest do
  use BanKu.DataCase

  alias BanKu.Reports

  describe "transactions" do
    alias BanKu.Reports.Transaction

    @valid_attrs %{account_dest_id: "some account_dest_id", account_origin_id: "some account_origin_id", amount: 42, date: "2010-04-17T14:00:00Z", operator_id: "some operator_id"}
    @update_attrs %{account_dest_id: "some updated account_dest_id", account_origin_id: "some updated account_origin_id", amount: 43, date: "2011-05-18T15:01:01Z", operator_id: "some updated operator_id"}
    @invalid_attrs %{account_dest_id: nil, account_origin_id: nil, amount: nil, date: nil, operator_id: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reports.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Reports.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Reports.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Reports.create_transaction(@valid_attrs)
      assert transaction.account_dest_id == "some account_dest_id"
      assert transaction.account_origin_id == "some account_origin_id"
      assert transaction.amount == 42
      assert transaction.date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert transaction.operator_id == "some operator_id"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reports.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Reports.update_transaction(transaction, @update_attrs)
      assert transaction.account_dest_id == "some updated account_dest_id"
      assert transaction.account_origin_id == "some updated account_origin_id"
      assert transaction.amount == 43
      assert transaction.date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert transaction.operator_id == "some updated operator_id"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Reports.update_transaction(transaction, @invalid_attrs)
      assert transaction == Reports.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Reports.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Reports.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Reports.change_transaction(transaction)
    end
  end
end
