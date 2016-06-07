defmodule EcPredictions.Favourite do
  use EcPredictions.Web, :model

  schema "favourites" do
    belongs_to :user, EcPredictions.User
    belongs_to :country, EcPredictions.Country

    field :delete, :boolean, virtual: true

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:country_id, :user_id, :delete])
    |> validate_required([:country_id, :user_id])
    |> mark_for_deletion()
  end

  defp mark_for_deletion(changeset) do
    # If delete was set and it is true, let's change the action
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
