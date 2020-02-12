defmodule BanKuWeb.Guardian do
  use Guardian, otp_app: :ban_ku

  alias BanKu.Accounts

  def subject_for_token(%{:id => id}, _claims), do: {:ok, to_string(id)}
  def subject_for_token(_, _), do: {:error, :invalid_resource}

  def resource_from_claims(claims), do: Accounts.get_user(claims["sub"])
end
