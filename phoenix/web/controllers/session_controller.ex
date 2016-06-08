defmodule EcPredictions.SessionController do
  use EcPredictions.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => user,
                                  "password" => pass}}) do
    case EcPredictions.Auth.login_by_email_and_pass(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        logged_in_user = Guardian.Plug.current_resource(conn)
        conn
        |> put_flash(:info, "Logged in successfully")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Unknown username or password")
        |> render("new.html")
     end
  end

  def delete(conn, _params) do
    conn
    |> EcPredictions.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
