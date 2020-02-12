defmodule BanKuWeb.UserControllerTest do
  use BanKuWeb.ConnCase

  alias BanKu.Accounts.User

  @backoffice_attrs %{
    email: "backoffice@banku.com",
    password: "lalala"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign_in" do
    test "renders jwt when credentials is valid", %{conn: conn} do
      # given
      %User{}
      |> User.changeset(@backoffice_attrs)
      |> Repo.insert()

      # when
      conn =
        post(conn, Routes.user_path(conn, :sign_in), %{
          "email" => @backoffice_attrs.email,
          "password" => @backoffice_attrs.password
        })

      # should
      assert Map.has_key?(json_response(conn, 200), "jwt")
    end

    test "renders errors when credentials is invalid", %{conn: conn} do
      # given
      %User{}
      |> User.changeset(@backoffice_attrs)
      |> Repo.insert()

      # when
      conn =
        post(conn, Routes.user_path(conn, :sign_in), %{
          "email" => @backoffice_attrs.email,
          "password" => "another password"
        })

      # should
      assert json_response(conn, 401) == %{"error" => "Login error"}
    end
  end
end
