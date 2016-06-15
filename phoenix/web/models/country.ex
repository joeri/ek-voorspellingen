defmodule EcPredictions.Country do
  use EcPredictions.Web, :model

  schema "countries" do
    field :name, :string

    has_many :home_games, EcPredictions.Game, foreign_key: :home_country_id
    has_many :away_games, EcPredictions.Game, foreign_key: :away_country_id

    timestamps
  end

  def points(home_games, away_games) do
    home_points = home_games
    |> Enum.map(fn game -> score_for(game.home_country_goals, game.away_country_goals) end)
    |> Enum.sum
    away_points = away_games
    |> Enum.map(fn game -> score_for(game.away_country_goals, game.home_country_goals) end)
    |> Enum.sum
    home_points + away_points
  end

  @doc """
  Builds a changeset based on the `country` and `params`.
  """
  def changeset(country, params \\ %{}) do
    country
    |> cast(params, [:name])
    |> validate_required([:name])
  end

  defp score_for(self_goals, other_goals) do
    cond do
      self_goals == nil         -> 0
      self_goals > other_goals  -> 5 + self_goals
      self_goals == other_goals -> 3 + self_goals
      self_goals < other_goals  -> 1 + self_goals
    end
  end
end
