defmodule EcPredictions.LeaderboardController do
  use EcPredictions.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias EcPredictions.User
  alias EcPredictions.Score


  def show(conn, _params) do
    users = Repo.all from u in User,
      join: s in Score,
      on: s.user_id == u.id,
      select: [u.name, s.points],
      order_by: [desc: s.points, asc: u.name]

    render(conn, "show.html", users: users)
  end
end
