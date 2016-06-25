defmodule EcPredictions.Prediction do
  use EcPredictions.Web, :model

  schema "predictions" do
    field :home_country_goals, :integer
    field :away_country_goals, :integer
    field :first_goal, :integer

    belongs_to :game, EcPredictions.Game
    belongs_to :user, EcPredictions.User

    timestamps
  end

  def points(%{game: game} = prediction) do
    cond do
    game.home_country_goals == nil -> 0
    same_home_country_goals(prediction) && same_away_country_goals(prediction) -> 7
    true ->
      subtotal = if same_winner(prediction) do 2 else 0 end
      if same_home_country_goals(prediction) || same_away_country_goals(prediction) do
        subtotal = subtotal + 1
      end
      subtotal
    end
  end

  defp same_home_country_goals(%{game: game} = prediction) do
    if game.round == 1 do
      prediction.home_country_goals == game.home_country_goals
    else
      prediction.home_country_goals == game.final_home_country_goals
    end
  end
  defp same_away_country_goals(%{game: game} = prediction) do
    if game.round == 1 do
      prediction.away_country_goals == game.away_country_goals
    else
      prediction.away_country_goals == game.final_away_country_goals
    end
  end
  defp same_winner(%{game: game} = prediction) do
    outcome_prediction = compare(prediction.away_country_goals, prediction.home_country_goals)
    outcome_game =
      if game.round == 1 do
        compare(game.away_country_goals, game.home_country_goals)
      else
        compare(game.final_away_country_goals, game.final_home_country_goals)
      end

    outcome_prediction == outcome_game
  end
  defp compare(a,b) do
    cond do
      a > b  ->  1
      a == b ->  0
      a < b  -> -1
    end
  end

  @doc """
  Builds a changeset based on the `prediction` and `params`.
  """
  def changeset(prediction, params \\ %{}) do
    prediction
    |> cast(params, [:home_country_goals, :away_country_goals, :game_id])
    |> validate_required([:home_country_goals, :away_country_goals])
    |> put_assoc(:user, params["user"])
    |> unique_constraint(:game_id, name: :predictions_user_id_game_id_index)
  end

  def update_changeset(prediction, params \\ %{}) do
    prediction
    |> cast(params, [:home_country_goals, :away_country_goals])
    |> validate_required([:home_country_goals, :away_country_goals])
  end

end
