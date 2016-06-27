defmodule EcPredictions.QualifiedController do
  use EcPredictions.Web, :controller
  alias EcPredictions.User
  alias EcPredictions.Qualified
  alias EcPredictions.Group

  def show(conn, _params) do
    user = conn |> Guardian.Plug.current_resource() |> Repo.preload(:qualifieds)
    groups = Group |> Repo.all() |> Repo.preload(country_groups: :country)
    render(conn, "show.html", user: user, qualifieds: user.qualifieds, groups: groups)
  end

  def update(conn, %{"qualifieds" => qualifieds_params} = params) do
    user = conn |> Guardian.Plug.current_resource() |> Repo.preload(:qualifieds)
    groups = Group |> Repo.all() |> Repo.preload(country_groups: :country)

    if Timex.after?(Timex.DateTime.now, Timex.datetime({{2016,6,15},{13,0,0}})) do
      conn
      |> put_flash(:error, "Too late to modify selection")
      |> render("show.html", user: user, favourites: user.favourites, groups: groups)
    else
      changes = Enum.flat_map qualifieds_params, fn {country, qualified} ->
        country_id = ~r/country\[(\d+)\]/ |> Regex.replace(country, "\\1") |> String.to_integer
        previously = Enum.find user.qualifieds, fn
          %Qualified{country_id: ^country_id} -> true
          _ -> false
        end

        if previously do
          [Qualified.changeset(previously, %{delete: qualified == "false"})]
        else
          if qualified == "true" do
            [Qualified.changeset(%Qualified{}, %{country_id: country_id, user_id: user.id})]
          else
            []
          end
        end
      end

      qualifieds = Enum.reject(changes, fn qual -> qual.action == :delete end)

      if length(qualifieds) > 16 do
        conn
        |> put_flash(:error, "Selected too many qualified countries")
        |> render("show.html", user: user, qualifieds: user.qualifieds, groups: groups)
      else
        user
        |> User.changeset(%{})
        |> Ecto.Changeset.put_assoc(:qualifieds, changes)
        |> Repo.update!()

        conn
        |> put_flash(:info, "Updated selection")
        |> redirect(to: qualified_path(conn, :show))
      end
    end
  end
end
