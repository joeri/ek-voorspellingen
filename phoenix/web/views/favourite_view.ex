defmodule EcPredictions.FavouriteView do
  use EcPredictions.Web, :view

  def is_favourite(favourites, country) do
    Enum.any? favourites, fn (fav) -> fav.country_id == country.id end
  end
end
