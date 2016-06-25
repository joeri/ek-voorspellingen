defmodule EcPredictions.Score do
  use EcPredictions.Web, :model
  alias EcPredictions.{Score,Prediction}

  schema "scores" do
    field :points, :integer
    belongs_to :user, EcPredictions.User

    timestamps
  end

  def calculate(user, country_scores, qualified_countries) do
    predictions = user.predictions
                  |> Enum.map(fn p -> Prediction.points(p) end)
                  |> Enum.sum

    favourites = user.favourites
                  |> Enum.map(fn f -> country_scores[f.country_id] end)
                  |> Enum.sum

    qualified = user.qualifieds
                |> Enum.filter(fn f -> MapSet.member?(qualified_countries, f.country_id) end)
                |> length

    predictions + favourites + 2 * qualified
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
