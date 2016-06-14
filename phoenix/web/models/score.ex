defmodule EcPredictions.Score do
  use EcPredictions.Web, :model
  alias EcPredictions.Repo
  alias EcPredictions.User
  alias EcPredictions.Score
  alias EcPredictions.Prediction

  schema "scores" do
    field :points, :integer
    belongs_to :user, EcPredictions.User

    timestamps
  end

  def calculate(user) do
    user.predictions
    |> Enum.map(fn p -> Prediction.points(p) end)
    |> Enum.sum
  end

  def update_all do
    inter = User
    |> Repo.all()
    |> Repo.preload([:score, predictions: :game])
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
