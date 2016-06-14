defmodule EcPredictions.Country do
  use EcPredictions.Web, :model

  schema "countries" do
    field :name, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `country` and `params`.
  """
  def changeset(country, params \\ %{}) do
    country
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
