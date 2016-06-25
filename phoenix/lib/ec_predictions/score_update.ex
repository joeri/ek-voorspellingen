defmodule EcPredictions.ScoreUpdate do
  alias EcPredictions.{Repo,Country,Score,User,Game}
  import Ecto.Query, only: [from: 2]

  def calculate_all_countries do
    Country
    |> Repo.all()
    |> Repo.preload([:home_games, :away_games])
    |> Enum.reduce(%{}, fn (country, acc) ->
        Map.put_new(acc, country.id, Country.points(country.home_games, country.away_games))
    end)
  end

  def update_all do
    all_countries = calculate_all_countries
    qualified_countries =
      (from g in Game, where: g.round == 2, select: [g.home_country_id, g.away_country_id]) |> Repo.all |> List.flatten |> MapSet.new

    User
    |> Repo.all()
    |> Repo.preload([:score, :favourites, :qualifieds, predictions: :game])
    |> Enum.map(fn user ->
      user.score
      |> Score.changeset(%{points: Score.calculate(user, all_countries, qualified_countries)})
      |> Repo.update
    end)
  end

end
