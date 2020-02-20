defmodule BanKu.Reports do
  @moduledoc """
  The Reports context.
  """

  import Ecto.Query, warn: false
  alias BanKu.Repo

  alias BanKu.Reports.Transaction

  @doc """
  Returns the list of transactions.

  it accepts aditional params to limit the transaction date

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

      iex> list_transactions(:year)
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  def list_transactions(:year) do
    {:ok, start_of_year} =
      %{Date.utc_today() | day: 1, month: 1}
      |> NaiveDateTime.new(~T[00:00:00])
      |> elem(1)
      |> DateTime.from_naive("Etc/UTC")

    transactions =
      Transaction
      |> where([t], t.date > ^start_of_year)
      |> Repo.all()

    transactions
  end

  def list_transactions(:month) do
    {:ok, start_of_month} =
      %{Date.utc_today() | day: 1}
      |> NaiveDateTime.new(~T[00:00:00])
      |> elem(1)
      |> DateTime.from_naive("Etc/UTC")

    transactions =
      Transaction
      |> where([t], t.date > ^start_of_month)
      |> Repo.all()

    transactions
  end

  def list_transactions(:day) do
    {:ok, start_of_day} =
      Date.utc_today()
      |> NaiveDateTime.new(~T[00:00:00])
      |> elem(1)
      |> DateTime.from_naive("Etc/UTC")

    transactions =
      Transaction
      |> where([t], t.date > ^start_of_day)
      |> Repo.all()

    transactions
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def gen_report() do
    %{
      total: get_transactions_amount(:total),
      year: get_transactions_amount(:year),
      month: get_transactions_amount(:month),
      day: get_transactions_amount(:day)
    }
  end

  defp get_transactions_amount(:total) do
    list_transactions()
    |> Enum.reduce(0, fn trans, total -> total + abs(trans.amount) end)
  end

  defp get_transactions_amount(interval) do
    list_transactions(interval)
    |> Enum.reduce(0, fn trans, total -> total + abs(trans.amount) end)
  end
end
