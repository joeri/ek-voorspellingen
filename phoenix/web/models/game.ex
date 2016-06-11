defmodule EcPredictions.Game do
  use EcPredictions.Web, :model

  schema "games" do
    field :start_time, Timex.Ecto.DateTime
    field :first_goal, :integer
    field :home_country_goals, :integer
    field :away_country_goals, :integer
    field :final_home_country_goals, :integer
    field :final_away_country_goals, :integer
    field :penalties_home_country_goals, :integer
    field :penalties_away_country_goals, :integer
    field :round, :integer
    belongs_to :home_country, EcPredictions.Country
    belongs_to :away_country, EcPredictions.Country

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start_time, :first_goal, :home_country_goals, :away_country_goals, :final_home_country_goals, :final_away_country_goals, :penalties_home_country_goals, :penalties_away_country_goals, :round])
    |> put_assoc(:away_country, params["away_country"])
    |> put_assoc(:home_country, params["home_country"])
    |> validate_required([:start_time, :round])
  end

  @doc """
  Changeset for when the final whistle has been blown and all results are known
  """
  def after_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:home_country_goals, :first_goal, :away_country_goals, :final_home_country_goals, :final_away_country_goals, :penalties_home_country_goals, :penalties_away_country_goals])
    |> validate_required([:home_country_goals, :away_country_goals])
    |> validate_inclusion(:first_goal, 1..120)
  end
end
