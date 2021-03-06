defmodule BanKu.AccountsTest do
  use BanKu.DataCase

  alias BanKu.Accounts

  describe "accounts" do
    alias BanKu.Accounts.{Account, User}

    @owner_name_example "some owner name"
    @owner_name_example_updated "some updated owner name"
    @owner_email_example "someemail@test.com"
    @owner_email_example_updated "anotheremail@test.com"

    @valid_attrs %{owner_name: @owner_name_example, email: @owner_email_example}
    @update_attrs %{
      balance: 43,
      owner_name: @owner_name_example_updated,
      email: @owner_email_example_updated
    }
    @invalid_attrs %{balance: nil, owner_name: nil, email: nil}

    @backoffice_attrs %{
      email: "backoffice@test.com",
      password: "lalala"
    }

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    def user_fixture(attrs \\ @backoffice_attrs) do
      {:ok, user} =
        %User{}
        |> User.changeset(attrs)
        |> Repo.insert()

      user
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
      assert account.email == @owner_email_example_updated
    end

    test "update_account/2 with valid partial data updates partially the account" do
      account = account_fixture()

      assert {:ok, %Account{} = account} =
               Accounts.update_account(account, %{
                 balance: 43,
                 owner_name: @owner_name_example_updated
               })

      assert account.balance == 43
      assert account.owner_name == @owner_name_example_updated
      assert account.email == @owner_email_example
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

    test "withdraw_from_account/3 with valid amount should return updated account" do
      # given
      account = account_fixture(%{balance: 100_000})
      user = user_fixture()
      amount = 100

      # when
      result = Accounts.withdraw_from_account(user.id, account.id, amount)

      # should
      assert {:ok, account_result} = result
      assert 99_900 == account_result.balance
    end

    test "withdraw_from_account/3 with invalid amount should return error" do
      # given
      account = account_fixture(%{balance: 100_000})
      user = user_fixture()
      amount = 100_001

      # when
      result = Accounts.withdraw_from_account(user.id, account.id, amount)

      # should
      assert {:error, :withdraw_not_allowed} = result
    end

    test "withdraw_from_account/3 with invalid account id should return error" do
      # given
      account_fixture(%{balance: 100_000})
      user = user_fixture()
      amount = 100

      # when
      result = Accounts.withdraw_from_account(user.id, "random string", amount)

      # should
      assert {:error, :withdraw_not_allowed} = result
    end

    test "transfer_from_accounts/4 with valid amount should return the transaction" do
      # given
      account_origin = account_fixture(%{balance: 100_000})
      account_dest = account_fixture(%{balance: 100_000, email: "another@user.com"})
      user = user_fixture()
      amount = 100

      # when
      result =
        Accounts.transfer_from_accounts(user.id, account_origin.id, account_dest.id, amount)

      # should
      assert {:ok, _} = result
      assert 99_900 == Accounts.get_account!(account_origin.id).balance
      assert 100_100 == Accounts.get_account!(account_dest.id).balance
    end

    test "transfer_from_accounts/4 with invalid amount should return error" do
      # given
      account_origin = account_fixture(%{balance: 100_000})
      account_dest = account_fixture(%{balance: 100_000, email: "another@user.com"})
      user = user_fixture()
      amount = -100

      # when
      result =
        Accounts.transfer_from_accounts(user.id, account_origin.id, account_dest.id, amount)

      # should
      assert {:error, :transfer_not_allowed} = result
    end

    test "transfer_from_accounts/4 with invalid account id should return error" do
      # given
      account_origin = account_fixture(%{balance: 100_000})
      user = user_fixture()
      amount = 100

      # when
      result =
        Accounts.transfer_from_accounts(user.id, account_origin.id, "someRandString", amount)

      # should
      assert {:error, :transfer_not_allowed} = result
    end

    test "token_sign_in/2 with valid email and password should return :ok" do
      # given
      user_fixture(@backoffice_attrs)

      # when
      result = Accounts.token_sign_in(@backoffice_attrs.email, @backoffice_attrs.password)

      # should
      assert {:ok, _, _} = result
    end

    test "token_sign_in/2 with invalid email should return :error" do
      # given
      user_fixture(@backoffice_attrs)

      # when
      result = Accounts.token_sign_in("invalid@email.com", @backoffice_attrs.password)

      # should
      assert {:error, _} = result
    end

    test "token_sign_in/2 with valid email and invalid password should return :error" do
      # given
      user_fixture(@backoffice_attrs)

      # when
      result = Accounts.token_sign_in(@backoffice_attrs.email, "wrong password")

      # should
      assert {:error, _} = result
    end
  end
end
