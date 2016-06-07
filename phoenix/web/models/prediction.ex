defmodule EcPredictions.Prediction do
  use EcPredictions.Web, :model

  schema "predictions" do
    field :home_country_goals, :integer
    field :away_country_goals, :integer
    field :first_goal, :integer
    belongs_to :game, EcPredictions.Game
    belongs_to :user, EcPredictions.User

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:home_country_goals, :away_country_goals, :first_goal])
    |> validate_required([:home_country_goals, :away_country_goals, :first_goal])
  end
end
