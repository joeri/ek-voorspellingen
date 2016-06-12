defmodule EcPredictions.ScoreTest do
  use EcPredictions.ModelCase

  alias EcPredictions.Score

  @valid_attrs %{score: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Score.changeset(%Score{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Score.changeset(%Score{}, @invalid_attrs)
    refute changeset.valid?
  end
end
