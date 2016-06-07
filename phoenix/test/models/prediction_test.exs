defmodule EcPredictions.PredictionTest do
  use EcPredictions.ModelCase

  alias EcPredictions.Prediction

  @valid_attrs %{away_country_goals: 42, first_goal: 42, home_country_goals: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Prediction.changeset(%Prediction{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Prediction.changeset(%Prediction{}, @invalid_attrs)
    refute changeset.valid?
  end
end
