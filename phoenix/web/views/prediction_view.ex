defmodule EcPredictions.PredictionView do
  use EcPredictions.Web, :view

  def show_prediction(predictions, game) do
    prediction = find_prediction(predictions, game.id)

    if prediction do
      "#{prediction.home_country_goals}-#{prediction.away_country_goals}"
    else
      ""
    end
  end

  def show_game(game) do
    if game.home_country_goals do
      EcPredictions.GameView.format_outcome(game)
    else
      ""
    end
  end

  def edit_or_create_prediction(conn, predictions, game) do
    prediction = find_prediction(predictions, game.id)
    if game.start_time <= Timex.DateTime.now do
      link("Show", to: game_path(conn, :show, game))
    else
      if prediction do
        link("Update", to: prediction_path(conn, :edit, prediction))
      else
        link("Predict", to: prediction_path(conn, :new, %{"game_id" => game.id}))
      end
    end
  end

  def format_time(time) do
    {:ok, result} = time
                    |> Timex.DateTime.local()
                    |> Timex.Format.DateTime.Formatter.format("{YYYY}-{M}-{D} {h24}:{m}")
    result
  end

  defp find_prediction(predictions, game_id) do
    prediction = Enum.find predictions, fn
      %{game_id: ^game_id} -> true
      _ -> false
    end
  end

end
