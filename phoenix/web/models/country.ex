defmodule EcPredictions.Country do
  use EcPredictions.Web, :model

  schema "countries" do
    field :name, :string

    has_many :home_games, EcPredictions.Game, foreign_key: :home_country_id
    has_many :away_games, EcPredictions.Game, foreign_key: :away_country_id

    has_many :favourited, EcPredictions.Favourite, foreign_key: :country_id
    has_many :favourited_by, through: [:favourited, :user]

    timestamps
  end

  def points(home_games, away_games) do
    home_points = home_games
    |> Enum.map(fn game -> {home,away} = scores_for(game); home end)
    |> Enum.sum
    away_points = away_games
    |> Enum.map(fn game -> {home,away} = scores_for(game); away end)
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

  defp scores_for(game) do
    home_goals = game.home_country_goals
    away_goals = game.away_country_goals

    cond do
      home_goals == nil         -> {0, 0}
      home_goals > away_goals  -> {5 + home_goals, 1 + away_goals}
      home_goals == away_goals ->
        if game.round == 1 do
          {3 + home_goals, 3 + away_goals}
        else
          home_score = [game.final_home_country_goals, game.penalties_home_country_goals]
          away_score = [game.final_away_country_goals, game.penalties_away_country_goals]

          if home_score > away_score do
            {5 + home_goals, 1 + away_goals}
          else
            {1 + home_goals, 5 + away_goals}
          end
        end
      home_goals < away_goals  -> {1 + home_goals, 5 + away_goals}
    end
  end
end
