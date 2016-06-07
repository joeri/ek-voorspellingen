defmodule EcPredictions.Repo.Migrations.CreatePrediction do
  use Ecto.Migration

  def change do
    create table(:predictions) do
      add :home_country_goals, :integer, null: false
      add :away_country_goals, :integer, null: false
      add :first_goal, :integer
      add :game_id, references(:games, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps
    end
    create index(:predictions, [:game_id])
    create index(:predictions, [:user_id])

  end
end
