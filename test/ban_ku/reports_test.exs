defmodule BanKu.ReportsTest do
  use BanKu.DataCase

  alias BanKu.Reports

  describe "transactions" do
    alias BanKu.Reports.Transaction

    @valid_attrs %{
      account_dest_id: "some account_dest_id",
      account_origin_id: "some account_origin_id",
      amount: 42,
      date: "2010-04-17T14:00:00Z",
      operator_id: "some operator_id"
    }
    @invalid_attrs %{
      account_dest_id: nil,
      account_origin_id: nil,
      amount: nil,
      date: nil,
      operator_id: nil
    }

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

    test "list_transactions(:year)" do
      # given
      transaction1 = transaction_fixture(%{date: DateTime.utc_now()})
      transaction2 = transaction_fixture(%{date: %{DateTime.utc_now() | year: 2_019}})

      # when
      result = Reports.list_transactions(:year)

      # should
      assert transaction1 in result
      assert transaction2 not in result
    end

    test "list_transactions(:month)" do
      # given
      today = DateTime.utc_now()
      transaction1 = transaction_fixture(%{date: today})

      transaction2 =
        transaction_fixture(%{
          date: DateTime.add(today, -31 * 24 * 3_600, :second)
        })

      # when
      result = Reports.list_transactions(:month)

      # should
      assert transaction1 in result
      assert transaction2 not in result
    end

    test "list_transactions(:day)" do
      # given
      today = DateTime.utc_now()
      transaction1 = transaction_fixture(%{date: today})

      transaction2 =
        transaction_fixture(%{
          date: DateTime.add(today, -24 * 3_600, :second)
        })

      # when
      result = Reports.list_transactions(:day)

      # should
      assert transaction1 in result
      assert transaction2 not in result
    end

    test "gen_report/0" do
      # given
      today = DateTime.utc_now()

      transaction_fixture(%{date: %{DateTime.utc_now() | year: 2_019}, amount: 1_000})

      transaction_fixture(%{
        date: DateTime.add(today, -24 * 3_600, :second),
        amount: -50
      })

      transaction_fixture(%{
        date: DateTime.add(today, -31 * 24 * 3_600, :second),
        amount: 10
      })

      transaction_fixture(%{
        date: today,
        amount: -1
      })

      # when
      result = Reports.gen_report()

      # should
      assert result == %{
               total: 1_061,
               year: 61,
               month: 51,
               day: 1
             }
    end
  end
end
