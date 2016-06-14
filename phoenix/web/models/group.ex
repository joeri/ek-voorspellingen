defmodule EcPredictions.Group do
  use EcPredictions.Web, :model

  schema "groups" do
    field :name, :string

    has_many :country_groups, EcPredictions.CountryGroup

    timestamps
  end

  @doc """
  Builds a changeset based on the `group` and `params`.
  """
  def changeset(group, params \\ %{}) do
    group
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
