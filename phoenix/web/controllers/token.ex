defmodule EcPredictions.Token do
  use EcPredictions.Web, :controller
  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:info, "You must be signed in to access this page")
    |> redirect(to: session_path(conn, :new))
  end

  def unauthorized(conn, _params) do
    conn
    |> put_flash(:info, "You must be signed in to access this page")
    |> redirect(to: page_path(conn, :index))
  end
end
