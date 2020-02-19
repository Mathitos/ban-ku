defmodule BanKuWeb.Guardian.ErrorHandler do
  @moduledoc """
  Guardian.ErrorHandler implementation for BanKu project
  """

  use BanKuWeb, :controller

  def auth_error(conn, {_type, _reason}, _opts),
    do: send_resp(conn, :unauthorized, "You must be authenticated to access this resource.")
end
