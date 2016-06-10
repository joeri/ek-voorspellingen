defmodule EcPredictions.CountryGroupTest do
  use EcPredictions.ModelCase

  alias EcPredictions.CountryGroup

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CountryGroup.changeset(%CountryGroup{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CountryGroup.changeset(%CountryGroup{}, @invalid_attrs)
    refute changeset.valid?
  end
end
