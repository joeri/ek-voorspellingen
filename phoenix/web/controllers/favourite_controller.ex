defmodule EcPredictions.FavouriteController do
  use EcPredictions.Web, :controller
  alias EcPredictions.User
  alias EcPredictions.Favourite
  alias EcPredictions.Country

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn) |> Repo.preload(:favourites)
    countries = Repo.all Country
    render(conn, "show.html", user: user, favourites: user.favourites, countries: countries)
  end

  def update(conn, %{"favourites" => favourites_params} = params) do
    user = Guardian.Plug.current_resource(conn) |> Repo.preload(:favourites)

    changes = Enum.flat_map favourites_params, fn {country, favourite} ->
      country_id = Regex.replace(~r/country\[(\d+)\]/, country, "\\1") |> String.to_integer
      previously = Enum.find user.favourites, fn
        %Favourite{country_id: ^country_id} -> true
        _ -> false
      end

      if previously do
        [Favourite.changeset(previously, %{ delete: favourite == "false" })]
      else
        if favourite == "true" do
          [Favourite.changeset(%Favourite{}, %{ country_id: country_id, user_id: user.id })]
        else
          []
        end
      end
    end

    favourites = Enum.reject(changes, fn fav -> fav.action == :delete end)
    countries = Repo.all Country

    if length(favourites) > 8 do
      conn
      |> put_flash(:info, "Selected too many favourites")
      |> render("show.html", user: user, favourites: user.favourites, countries: countries)
    else
      User.changeset(user, %{})
      |> Ecto.Changeset.put_assoc(:favourites, changes)
      |> Repo.update!()

      conn
      |> put_flash(:info, "Updated selection")
      |> redirect(to: favourite_path(conn, :show))
    end
  end
end
