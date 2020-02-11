defmodule BanKuWeb.WithdrawControllerTest do
  use BanKuWeb.ConnCase

  alias BanKu.Accounts

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "withdraw" do
    test "renders account when data is valid", %{conn: conn} do
      # given
      {:ok, account} = Accounts.create_account(%{owner_name: "owner name example"})
      account_id = account.id

      # when
      conn =
        post(conn, Routes.withdraw_path(conn, :withdraw), %{
          "account_id" => account_id,
          "amount" => 100
        })

      # should
      assert %{
               "id" => account_id,
               "balance" => 99_900,
               "owner_name" => "owner name example"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      # when
      conn = post(conn, Routes.withdraw_path(conn, :withdraw), %{})

      # should
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when account id is invalid", %{conn: conn} do
      # when
      conn =
        post(conn, Routes.withdraw_path(conn, :withdraw), %{
          "account_id" => "some invalid id",
          "amount" => 100
        })

      # should
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "renders errors when amount is invalid", %{conn: conn} do
      # given
      {:ok, account} = Accounts.create_account(%{owner_name: "owner name example"})
      account_id = account.id

      # when
      conn =
        post(conn, Routes.withdraw_path(conn, :withdraw), %{
          "account_id" => account_id,
          "amount" => -100
        })

      # should
      assert json_response(conn, 400)["errors"] != %{}
    end
  end
end
