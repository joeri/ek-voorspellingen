defmodule EcPredictions.PredictionController do
  use EcPredictions.Web, :controller
  alias EcPredictions.User
  alias EcPredictions.Game
  alias EcPredictions.Prediction

  def index(conn, _params) do
    user = conn |> Guardian.Plug.current_resource() |> Repo.preload(:predictions)
    games = (from g in Game, order_by: [desc: g.round, asc: g.start_time, asc: g.id])
            |> Repo.all()
            |> Repo.preload([:home_country, :away_country])

    render(conn, "index.html", games: games, predictions: user.predictions)
  end

  def new(conn, %{"game_id" => game_id}) do
    user = conn |> Guardian.Plug.current_resource() |> Repo.preload(:predictions)
    game = Game |> Repo.get(game_id) |> Repo.preload([:home_country, :away_country])
    changeset = Prediction.changeset(%Prediction{}, %{"game_id" => game_id})

    if Timex.after?(Timex.DateTime.now, game.start_time) do
      conn
      |> put_flash(:error, "Game has started or is over")
      |> redirect(to: prediction_path(conn, :index))
    else
      render(conn, "new.html", game: game, changeset: changeset)
    end
  end
  def new(conn, _params) do
    conn
    |> put_flash(:error, "You can only predict a specific game.")
    |> redirect(to: prediction_path(conn, :index))
  end

  def create(conn, %{"prediction" => prediction_params}) do
    user = conn |> Guardian.Plug.current_resource() |> Repo.preload(:predictions)
    game = Game |> Repo.get(prediction_params["game_id"]) |> Repo.preload([:home_country, :away_country])
    changeset = Prediction.changeset(%Prediction{}, Map.put(prediction_params, "user", user))

    if Timex.after?(Timex.DateTime.now, game.start_time) do
      conn
      |> put_flash(:error, "Game has started or is over")
      |> redirect(to: prediction_path(conn, :index))
    else
      case Repo.insert(changeset) do
        {:ok, prediction} ->
          conn
          |> put_flash(:info, "Prediction made!")
          |> redirect(to: prediction_path(conn, :index))
        {:error, changeset} ->
          conn
          |> put_flash(:error, "Couldn't create the prediction")
          |> render("new.html", game: game, changeset: changeset)
      end
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    prediction = Prediction |> Repo.get(id) |> Repo.preload(game: [:home_country, :away_country])
    changeset = Prediction.update_changeset(prediction)

    cond do
      Timex.after?(Timex.DateTime.now, prediction.game.start_time) ->
        conn
        |> put_flash(:error, "Game has started or is over")
        |> redirect(to: prediction_path(conn, :index))
      user.id == prediction.user_id ->
          render(conn, "edit.html", game: prediction.game, prediction: prediction, changeset: changeset)
      true ->
        conn
        |> put_flash(:error, "You can only modify your own predictions.")
        |> redirect(to: prediction_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "prediction" => prediction_params}) do
    user = Guardian.Plug.current_resource(conn)
    prediction = Prediction |> Repo.get(id) |> Repo.preload(:game)
    changeset = Prediction.update_changeset(prediction, prediction_params)

    if user.id == prediction.user_id do
      case Repo.update(changeset) do
        {:ok, _prediction} ->
          conn
          |> put_flash(:info, "Updated prediction")
          |> redirect(to: prediction_path(conn, :index))
        {:error, changeset} ->
          render(conn, "edit.html", game: prediction.game, prediction: prediction, changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "You can only modify your own predictions.")
      |> redirect(to: prediction_path(conn, :index))
    end
  end
end
