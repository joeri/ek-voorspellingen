defmodule EcPredictions.CountryGroup do
  use EcPredictions.Web, :model

  schema "country_groups" do
    belongs_to :country, EcPredictions.Country
    belongs_to :group, EcPredictions.Group

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
    |> unique_constraint(:country_id)
  end
end
