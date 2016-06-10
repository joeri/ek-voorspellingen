defmodule EcPredictions.Group do
  use EcPredictions.Web, :model

  schema "groups" do
    field :name, :string
    belongs_to :seed, EcPredictions.Group
    belongs_to :bottom, EcPredictions.Group

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> unique_constraint(:seed_id)
    |> unique_constraint(:bottom_id)
  end
end
