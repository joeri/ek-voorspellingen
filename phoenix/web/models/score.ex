defmodule EcPredictions.Score do
  use EcPredictions.Web, :model
  alias EcPredictions.{Repo,User,Score,Prediction,Country}

  schema "scores" do
    field :points, :integer
    belongs_to :user, EcPredictions.User

    timestamps
  end

  def calculate(user, country_scores \\ calculate_all_countries) do
    predictions = user.predictions
    |> Enum.map(fn p -> Prediction.points(p) end)
    |> Enum.sum

    favourites = user.favourites
    |> Enum.map(fn f -> country_scores[f.country_id] end)
    |> Enum.sum

    predictions + favourites
  end

  def calculate_all_countries do
    Country
    |> Repo.all()
    |> Repo.preload([:home_games, :away_games])
    |> Enum.reduce(%{}, fn (country, acc) ->
        Map.put_new(acc, country.id, Country.points(country.home_games, country.away_games))
    end)
  end

  def update_all do
    User
    |> Repo.all()
    |> Repo.preload([:score, :favourites, predictions: :game])
    |> Enum.map(fn user -> user.score |> Score.changeset(%{points: Score.calculate(user)}) |> Repo.update end)
  end

  def new do
    changeset(%Score{}, %{points: 0})
  end

  @doc """
  Builds a changeset based on the `score` and `params`.
  """
  def changeset(score, params \\ %{}) do
    score
    |> cast(params, [:points])
    |> validate_required([:points])
    |> unique_constraint(:user_id)
  end
end
