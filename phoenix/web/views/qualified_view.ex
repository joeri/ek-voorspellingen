defmodule EcPredictions.QualifiedView do
  use EcPredictions.Web, :view

  def is_qualified(qualifieds, country) do
    Enum.any? qualifieds, fn (qual) -> qual.country_id == country.id end
  end
end
