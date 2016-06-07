defmodule EcPredictions.UserController do
  use EcPredictions.Web, :controller
  alias EcPredictions.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user)
    render(conn, "show.html", user: user, changeset: changeset)
  end

  def new(conn, _params) do
    changeset = User.registration_changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Registered successfully")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user, user_params)

    cond do
      user == Guardian.Plug.current_resource(conn) ->
        case Repo.update(changeset) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "User updated")
            |> redirect(to: page_path(conn, :index))
          {:error, changeset} ->
            conn
            |> render("show.html", user: user, changeset: changeset)
        end
      :error ->
        conn
        |> put_flash(:info, "No access")
        |> redirect(to: page_path(conn, :index))
    end
  end
end
