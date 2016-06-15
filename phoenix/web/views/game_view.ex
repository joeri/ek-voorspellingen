defmodule EcPredictions.GameView do
  use EcPredictions.Web, :view

  def format_time(time) do
    {:ok, result} = time
                    |> Timex.DateTime.local()
                    |> Timex.Format.DateTime.Formatter.format("{YYYY}-{M}-{D} {h24}:{m}")
    result
  end

end
