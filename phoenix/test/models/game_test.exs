defmodule EcPredictions.GameTest do
  use EcPredictions.ModelCase

  alias EcPredictions.Game

  @valid_attrs %{away_country_goals: 42, final_away_country_goals: 42, final_home_country_goals: 42, home_country_goals: 42, penalties_away_country_goals: 42, penalties_home_country_goals: 42, round: 42, start_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Game.changeset(%Game{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Game.changeset(%Game{}, @invalid_attrs)
    refute changeset.valid?
  end
end
