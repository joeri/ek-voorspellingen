defmodule EcPredictions.Repo.Migrations.AddUniquenessConstraintOnPredictions do
  use Ecto.Migration

  def change do
    create unique_index(:predictions, [:user_id, :game_id])
  end
end
