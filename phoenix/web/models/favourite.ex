defmodule EcPredictions.Favourite do
  use EcPredictions.Web, :model

  schema "favourites" do
    belongs_to :user, EcPredictions.User
    belongs_to :country, EcPredictions.Country

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
