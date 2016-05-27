defmodule EcPredictions.PageController do
  use EcPredictions.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
