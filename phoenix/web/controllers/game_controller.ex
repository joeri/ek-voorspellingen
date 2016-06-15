defmodule EcPredictions.GameController do
  use EcPredictions.Web, :controller
  alias EcPredictions.Game

  def show(conn, %{"id" => id}) do
    game = Game |> Repo.get(id) |> Repo.preload([[predictions: [:user,:game]], :home_country, :away_country])

    if game.start_time <= Timex.DateTime.now do
      conn
      |> render("show.html", game: game)
    else
      conn
      |> put_flash(:error, "No permission to view predictions for this game yet")
      |> redirect(to: prediction_path(conn, :index))
    end
  end
end
