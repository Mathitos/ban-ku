defmodule BanKuWeb.TransactionControllerTest do
  use BanKuWeb.ConnCase

  alias BanKu.{Reports, Accounts}

  @create_attrs %{
    account_dest_id: "some account_dest_id",
    account_origin_id: "some account_origin_id",
    amount: 42,
    date: "2010-04-17T14:00:00Z",
    operator_id: "some operator_id"
  }

  def fixture(:transaction) do
    {:ok, transaction} = Reports.create_transaction(@create_attrs)
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
      transaction = fixture(:transaction)

      # when
      conn = get(conn, Routes.transaction_path(conn, :index))

      # should
      assert length(json_response(conn, 200)["data"]) == 1
      assert Enum.at(json_response(conn, 200)["data"], 0)["id"] == transaction.id
    end
  end
end
