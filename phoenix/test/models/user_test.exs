defmodule EcPredictions.UserTest do
  use EcPredictions.ModelCase

  alias EcPredictions.User

  @valid_attrs %{email: "some content", name: "some content", password_hash: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Users.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Users.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
