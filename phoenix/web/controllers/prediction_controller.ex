defmodule EcPredictions.PredictionController do
  use EcPredictions.Web, :controller
  alias EcPredictions.User
  alias EcPredictions.Game
  alias EcPredictions.Prediction

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn) |> Repo.preload(:predictions)
    games = Repo.all(Game) |> Repo.preload([:home_country, :away_country])

    render(conn, "index.html", games: games, predictions: user.predictions)
  end

  def new(conn, %{ "game_id" => game_id }) do
    user = Guardian.Plug.current_resource(conn) |> Repo.preload(:predictions)
    game = Repo.get(Game, game_id) |> Repo.preload([:home_country, :away_country])
    changeset = Prediction.changeset(%Prediction{}, %{ "game_id" => game_id })

    IO.inspect changeset

    render(conn, "new.html", game: game, changeset: changeset)
  end
  def new(conn, _params) do
    conn
    |> put_flash(:error, "You can only predict a specific game.")
    |> redirect(to: prediction_path(conn, :index))
  end

  def create(conn, %{ "prediction" => prediction_params }) do
    user = Guardian.Plug.current_resource(conn) |> Repo.preload(:predictions)
    game = Repo.get(Game, prediction_params["game_id"]) |> Repo.preload([:home_country, :away_country])
    changeset = Prediction.changeset(%Prediction{}, Map.put(prediction_params, "user", user))

    case Repo.insert(changeset) do
      {:ok, prediction} ->
        conn
        |> put_flash(:info, "Prediction made!")
        |> redirect(to: prediction_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", game: game, changeset: changeset)
    end
  end

  def edit(conn, %{ "id" => id }) do
    user = Guardian.Plug.current_resource(conn)
    prediction = Repo.get(Prediction, id) |> Repo.preload(game: [:home_country, :away_country])
    changeset = Prediction.update_changeset(prediction)

    cond do
      user.id == prediction.user_id ->
        render(conn, "edit.html", game: prediction.game, prediction: prediction, changeset: changeset)
      true ->
        conn
        |> put_flash(:error, "You can only modify your own predictions.")
        |> redirect(to: prediction_path(conn, :index))
    end
  end

  def update(conn, %{ "id" => id, "prediction" => prediction_params }) do
    user = Guardian.Plug.current_resource(conn)
    prediction = Repo.get(Prediction, id) |> Repo.preload(:game)
    changeset = Prediction.update_changeset(prediction, prediction_params)
    IO.inspect changeset

    cond do
      user.id == prediction.user_id ->
        case Repo.update(changeset) do
          {:ok, _prediction} ->
            conn
            |> put_flash(:info, "Updated prediction")
            |> redirect(to: prediction_path(conn, :index))
          {:error, changeset} ->
            render(conn, "edit.html", game: prediction.game, prediction: prediction, changeset: changeset)
        end
      true ->
        conn
        |> put_flash(:error, "You can only modify your own predictions.")
        |> redirect(to: prediction_path(conn, :index))
    end
  end
end
