defmodule BanKu.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BanKu.Repo
  alias BanKuWeb.Guardian
  alias BanKu.Accounts.{Account, User}
  alias BanKu.Reports.Transaction
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(account_params \\ %{}) do
    attrs = Map.put(account_params, :balance, Account.get_initial_value())

    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  @doc """
  Withdraw money from an account.

  ## Examples

      iex> withdraw_from_account(operator_id, account_id, amount)
      {:ok, %Account{}}

      iex> withdraw_from_account(operator_id, account_id, invalid_amount})
      {:error, %Ecto.Changeset{}}

  """
  def withdraw_from_account(operator_id, acount_id, amount) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:id, fn _repo, _changes -> validate_uuid(acount_id) end)
    |> Ecto.Multi.run(:account, fn repo, %{id: id} -> get_account(repo, id) end)
    |> Ecto.Multi.run(:withdraw_changeset, fn _repo, %{account: account} ->
      withdraw_changeset(account, amount)
    end)
    |> Ecto.Multi.run(:account_updated, fn repo, %{withdraw_changeset: withdraw_changeset} ->
      repo.update(withdraw_changeset)
    end)
    |> Ecto.Multi.insert(
      :transaction,
      %Transaction{
        account_origin_id: acount_id,
        account_dest_id: nil,
        amount: -amount,
        date: DateTime.utc_now() |> DateTime.truncate(:second),
        operator_id: operator_id
      }
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{account_updated: account_updated}} -> {:ok, account_updated}
      _ -> {:error, :withdraw_not_allowed}
    end
  end

  defp validate_uuid(uuid) do
    case Ecto.UUID.cast(uuid) do
      {:ok, id} -> {:ok, id}
      err -> {:error, err}
    end
  end

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end

  defp withdraw_changeset(account, amount) when is_number(amount) and amount > 0 do
    remaining_balance = account.balance - amount
    {:ok, Account.changeset(account, %{balance: remaining_balance})}
  end

  defp withdraw_changeset(_, _),
    do: {:error, :invalid_amount}

  @doc """
  Gets a single user or nil it doesnt exists.

  ## Examples

      iex> get_user(123)
      %Account{}

      iex> get_user(456)
      nil

  """
  def get_user(id), do: Repo.get(User, id)

  defp get_user_by_email(email) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        dummy_checkpw()
        {:error, :login_error}

      user ->
        {:ok, user}
    end
  end

  defp verify_password(password, %User{} = user) when is_binary(password) do
    if checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end

  defp verify_password(_, _), do: {:error, :invalid_password}

  defp user_auth(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- get_user_by_email(email),
         do: verify_password(password, user)
  end

  @doc """
  encode and signin, or return a error in case user dont exists or is wrong password

  ## Examples

      iex> token_sign_in(email, password)
      {:ok, token, claims}

      iex> token_sign_in(email, password)
      {:error, :unauthorized}

  """
  def token_sign_in(email, password) do
    case user_auth(email, password) do
      {:ok, user} ->
        Guardian.encode_and_sign(user)

      _ ->
        {:error, :unauthorized}
    end
  end
end
