defmodule BanKu.AccountsTest do
  use BanKu.DataCase

  alias BanKu.Accounts

  describe "accounts" do
    alias BanKu.Accounts.Account

    @owner_name_example "some owner name"
    @owner_name_example_updated "some updated owner name"

    @valid_attrs %{owner_name: @owner_name_example}
    @update_attrs %{balance: 43, owner_name: @owner_name_example_updated}
    @invalid_attrs %{balance: nil, owner_name: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account with correct balance" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.balance == Account.get_initial_value()
      assert account.owner_name == @owner_name_example
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.balance == 43
      assert account.owner_name == @owner_name_example_updated
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end

    test "update_account/2 with negative balance returns error changeset" do
      # given
      account = account_fixture()
      update_attrs_negative_balance = %{balance: -20_000}

      # when
      changeset_result = Accounts.update_account(account, update_attrs_negative_balance)

      # should
      assert {:error, %Ecto.Changeset{}} = changeset_result
      assert account == Accounts.get_account!(account.id)
    end

    test "withdraw_from_account/2 with valid amount should return updated account" do
      # given
      account = account_fixture(%{balance: 100_000})
      amount = 100

      # when
      result = Accounts.withdraw_from_account(account.id, amount)

      # should
      assert {:ok, account_result} = result
      assert 99900 == account_result.balance
    end

    test "withdraw_from_account/2 with invalid amount should return error" do
      # given
      account = account_fixture(%{balance: 100_000})
      amount = 100_001

      # when
      result = Accounts.withdraw_from_account(account.id, amount)

      # should
      assert {:error, :withdraw_not_allowed} = result
    end
  end
end
