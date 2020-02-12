defmodule Banku.Seeds do
  alias BanKu.Accounts.User
  alias BanKu.Repo

  @backoffice_credentials %{
    email: "backoffice@banku.com",
    password: "lalala"
  }

  def run do
    %User{}
    |> User.changeset(@backoffice_credentials)
    |> Repo.insert()
  end
end

Banku.Seeds.run()
