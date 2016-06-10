defmodule EcPredictions.CountryGroup do
  use EcPredictions.Web, :model

  schema "country_groups" do
    field :rank, :integer
    belongs_to :country, EcPredictions.Country
    belongs_to :group, EcPredictions.Group

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:rank])
    |> validate_required([:rank])
    |> put_assoc(:group, params["group"])
    |> put_assoc(:country, params["country"])
    |> unique_constraint(:country_id)
    |> unique_constraint(:country_groups_group_id_rank_index)
  end
end
