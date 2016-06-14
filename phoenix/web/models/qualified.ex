defmodule EcPredictions.Qualified do
  use EcPredictions.Web, :model

  schema "qualifieds" do
    belongs_to :user, EcPredictions.User
    belongs_to :country, EcPredictions.Country

    field :delete, :boolean, virtual: true

    timestamps
  end

  @doc """
  Builds a changeset based on the `qualified` and `params`.
  """
  def changeset(qualified, params \\ %{}) do
    qualified
    |> cast(params, [:user_id, :country_id, :delete])
    |> validate_required([:user_id, :country_id])
    |> mark_for_deletion()
  end

  defp mark_for_deletion(cs) do
    # If delete was set and it is true, let's change the action
    if get_change(cs, :delete) do
      %{cs | action: :delete}
    else
      cs
    end
  end
end
