defmodule EcPredictions.QualifiedTest do
  use EcPredictions.ModelCase

  alias EcPredictions.Qualified

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Qualified.changeset(%Qualified{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Qualified.changeset(%Qualified{}, @invalid_attrs)
    refute changeset.valid?
  end
end
