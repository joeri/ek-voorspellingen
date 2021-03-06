defmodule EcPredictions.FavouriteController do
  use EcPredictions.Web, :controller
  alias EcPredictions.User
  alias EcPredictions.Favourite
  alias EcPredictions.Group

  def show(conn, _params) do
    user = conn |> Guardian.Plug.current_resource() |> Repo.preload(:favourites)
    groups = Group |> Repo.all() |> Repo.preload(country_groups: :country)
    render(conn, "show.html", user: user, favourites: user.favourites, groups: groups)
  end

  def update(conn, %{"favourites" => favourites_params} = params) do
    user = conn |> Guardian.Plug.current_resource() |> Repo.preload(:favourites)
    groups = Group |> Repo.all() |> Repo.preload(country_groups: :country)

    if Timex.after?(Timex.DateTime.now, Timex.datetime({{2016,6,15},{13,0,0}})) do
      conn
      |> put_flash(:error, "Too late to modify selection")
      |> render("show.html", user: user, favourites: user.favourites, groups: groups)
    else
      changes = Enum.flat_map favourites_params, fn {country, favourite} ->
        country_id = ~r/country\[(\d+)\]/ |> Regex.replace(country, "\\1") |> String.to_integer
        previously = Enum.find user.favourites, fn
          %Favourite{country_id: ^country_id} -> true
          _ -> false
        end

        if previously do
          [Favourite.changeset(previously, %{delete: favourite == "false"})]
        else
          if favourite == "true" do
            [Favourite.changeset(%Favourite{}, %{country_id: country_id, user_id: user.id})]
          else
            []
          end
        end
      end

      favourites = Enum.reject(changes, fn fav -> fav.action == :delete end)

      if length(favourites) > 8 do
        conn
        |> put_flash(:error, "Selected too many favourites")
        |> render("show.html", user: user, favourites: user.favourites, groups: groups)
      else
        user
        |> User.changeset(%{})
        |> Ecto.Changeset.put_assoc(:favourites, changes)
        |> Repo.update!()

        conn
        |> put_flash(:info, "Updated selection")
        |> redirect(to: favourite_path(conn, :show))
      end
    end
  end
end
