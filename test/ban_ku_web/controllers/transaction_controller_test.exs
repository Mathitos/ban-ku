defmodule BanKuWeb.TransactionControllerTest do
  use BanKuWeb.ConnCase

  alias BanKu.{Accounts, Reports}

  @create_attrs %{
    account_dest_id: "some account_dest_id",
    account_origin_id: "some account_origin_id",
    amount: 42,
    date: "2010-04-17T14:00:00Z",
    operator_id: "some operator_id"
  }

  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(@create_attrs)
      |> Reports.create_transaction()

    transaction
  end

  setup %{conn: conn} do
    {:ok, token, _claims} = Accounts.token_sign_in("backoffice@banku.com", "password")

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      # given
      transaction = transaction_fixture()

      # when
      conn = get(conn, Routes.transaction_path(conn, :index))

      # should
      assert length(json_response(conn, 200)["data"]) == 1
      assert Enum.at(json_response(conn, 200)["data"], 0)["id"] == transaction.id
    end
  end

  describe "reports" do
    test "generate report with all fields", %{conn: conn} do
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
      conn = get(conn, Routes.transaction_path(conn, :report))

      # should
      assert json_response(conn, 200) == %{
               "total" => 1_061,
               "year" => 61,
               "month" => 51,
               "day" => 1
             }
    end
  end
end
