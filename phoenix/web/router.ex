defmodule EcPredictions.Router do
  use EcPredictions.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated, handler: EcPredictions.Token
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EcPredictions do
    pipe_through :browser # Use the default browser stack

    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", EcPredictions do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
    resources "/user", UserController, only: [:show, :index, :update]
    get "/favourites", FavouriteController, :show
    post "/favourites", FavouriteController, :update
    get "/qualifieds", QualifiedController, :show
    post "/qualifieds", QualifiedController, :update
    resources "/predictions", PredictionController
    resources "/games", GameController, only: [:show]

    get "/leaderboard", LeaderboardController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", EcPredictions do
  #   pipe_through :api
  # end
end
