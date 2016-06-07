defmodule EcPredictions.QualifiedController do
  use EcPredictions.Web, :controller
  alias EcPredictions.User
  alias EcPredictions.Qualified
  alias EcPredictions.Country

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn) |> Repo.preload(:qualifieds)
    countries = Repo.all Country
    render(conn, "show.html", user: user, qualifieds: user.qualifieds, countries: countries)
  end

  def update(conn, %{"qualifieds" => qualifieds_params} = params) do
    user = Guardian.Plug.current_resource(conn) |> Repo.preload(:qualifieds)

    changes = Enum.flat_map qualifieds_params, fn {country, qualified} ->
      country_id = Regex.replace(~r/country\[(\d+)\]/, country, "\\1") |> String.to_integer
      previously = Enum.find user.qualifieds, fn
        %Qualified{country_id: ^country_id} -> true
        _ -> false
      end

      if previously do
        [Qualified.changeset(previously, %{ delete: qualified == "false" })]
      else
        if qualified == "true" do
          [Qualified.changeset(%Qualified{}, %{ country_id: country_id, user_id: user.id })]
        else
          []
        end
      end
    end

    qualifieds = Enum.reject(changes, fn qual -> qual.action == :delete end)
    countries = Repo.all Country

    if length(qualifieds) > 16 do
      conn
      |> put_flash(:info, "Selected too many qualified countries")
      |> render("show.html", user: user, qualifieds: user.qualifieds, countries: countries)
    else
      User.changeset(user, %{})
      |> Ecto.Changeset.put_assoc(:qualifieds, changes)
      |> Repo.update!()

      redirect(conn, to: qualified_path(conn, :show))
    end
  end
end
