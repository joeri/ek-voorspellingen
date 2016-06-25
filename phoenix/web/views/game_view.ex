defmodule EcPredictions.GameView do
  use EcPredictions.Web, :view

  def format_time(time) do
    {:ok, result} = time
                    |> Timex.DateTime.local()
                    |> Timex.Format.DateTime.Formatter.format("{YYYY}-{M}-{D} {h24}:{m}")
    result
  end

  def format_outcome(game) do
    if game.round == 1 do
      "#{game.home_country_goals}-#{game.away_country_goals}"
    else
      if game.final_home_country_goals == game.final_away_country_goals do
        "#{game.final_home_country_goals}-#{game.final_away_country_goals} (#{game.penalties_home_country_goals}-#{game.penalties_away_country_goals})"
      else
        "#{game.final_home_country_goals}-#{game.final_away_country_goals}"
      end
    end
  end

end
