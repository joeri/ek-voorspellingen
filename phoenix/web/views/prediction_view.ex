defmodule EcPredictions.PredictionView do
  use EcPredictions.Web, :view

  def edit_or_create_prediction(conn, predictions, %{ :id => game_id } = game) do
    prediction = Enum.find predictions, fn
      %{ game_id: ^game_id } -> true
      _ -> false
    end

    if game.start_time <= Timex.DateTime.now do
      ""
    else
      if prediction do
        link("Update", to: prediction_path(conn, :edit, prediction))
      else
        link("Predict", to: prediction_path(conn, :new, %{ "game_id" => game_id }))
      end
    end
  end

  def format_time(time) do
    {:ok, result} = time
                    |> Timex.DateTime.local()
                    |> Timex.Format.DateTime.Formatter.format("{YYYY}-{M}-{D} {h24}:{m}")
    result
  end
end
