defmodule EcPredictions.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :start_time, :datetime, null: false
      add :first_goal, :integer
      add :home_country_goals, :integer
      add :away_country_goals, :integer
      add :final_home_country_goals, :integer
      add :final_away_country_goals, :integer
      add :penalties_home_country_goals, :integer
      add :penalties_away_country_goals, :integer
      add :round, :integer, null: false
      add :home_country_id, references(:countries, on_delete: :nothing), null: false
      add :away_country_id, references(:countries, on_delete: :nothing), null: false

      timestamps
    end
    create index(:games, [:home_country_id])
    create index(:games, [:away_country_id])

  end
end
