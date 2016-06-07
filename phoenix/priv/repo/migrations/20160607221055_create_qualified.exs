defmodule EcPredictions.Repo.Migrations.CreateQualified do
  use Ecto.Migration

  def change do
    create table(:qualifieds) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :country_id, references(:countries, on_delete: :nothing), null: false

      timestamps
    end
    create index(:qualifieds, [:user_id])
    create index(:qualifieds, [:country_id])

  end
end
