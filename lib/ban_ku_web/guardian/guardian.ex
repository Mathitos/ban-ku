defmodule BanKuWeb.Guardian do
  @moduledoc """
  Guardian implementation for BanKu project
  """

  use Guardian, otp_app: :ban_ku

  alias BanKu.Accounts

  def subject_for_token(%{:id => id}, _claims), do: {:ok, to_string(id)}
  def subject_for_token(_, _), do: {:error, :invalid_resource}

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end
end
