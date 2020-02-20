defmodule BanKuWeb.TransferControllerTest do
  use BanKuWeb.ConnCase

  alias BanKu.Accounts

  @create_attrs %{owner_name: "owner name example", email: "owner_name@email.com"}

  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(@create_attrs)
      |> Accounts.create_account()

    account
  end

  setup %{conn: conn} do
    {:ok, token, _claims} = Accounts.token_sign_in("backoffice@banku.com", "password")

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn}
  end

  describe "transfer" do
    test "renders transaction when data is valid", %{conn: conn} do
      # given
      account_origin = account_fixture()
      account_dest = account_fixture(%{email: "other@person.com"})
      amount = 100

      account_origin_id = account_origin.id
      account_dest_id = account_dest.id

      # when
      conn =
        post(conn, Routes.transfer_path(conn, :transfer), %{
          "account_origin_id" => account_origin_id,
          "account_dest_id" => account_dest_id,
          "amount" => amount
        })

      # should
      assert json_response(conn, 200)["data"]["account_origin_id"] == account_origin_id
      assert json_response(conn, 200)["data"]["account_dest_id"] == account_dest_id
      assert json_response(conn, 200)["data"]["amount"] == amount
    end

    test "renders errors when data is invalid", %{conn: conn} do
      # when
      conn = post(conn, Routes.transfer_path(conn, :transfer), %{})

      # should
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when account id is invalid", %{conn: conn} do
      # given
      account_origin = account_fixture()
      amount = 100

      account_origin_id = account_origin.id

      # when
      conn =
        post(conn, Routes.transfer_path(conn, :transfer), %{
          "account_origin_id" => account_origin_id,
          "account_dest_id" => "some random string",
          "amount" => amount
        })

      # should
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "renders errors when amount is invalid", %{conn: conn} do
      # given
      account_origin = account_fixture()
      account_dest = account_fixture(%{email: "other@person.com"})
      amount = -100

      account_origin_id = account_origin.id
      account_dest_id = account_dest.id

      # when
      conn =
        post(conn, Routes.transfer_path(conn, :transfer), %{
          "account_origin_id" => account_origin_id,
          "account_dest_id" => account_dest_id,
          "amount" => amount
        })

      # should
      assert json_response(conn, 400)["errors"] != %{}
    end
  end
end
