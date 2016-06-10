defmodule EcPredictions.Repo.Migrations.CreateGroup do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string, null: false
      add :seed_id, references(:countries, on_delete: :nothing), null: false
      add :bottom_id, references(:countries, on_delete: :nothing), null: false

      timestamps
    end
    create unique_index(:groups, [:name])
    create unique_index(:groups, [:seed_id])
    create unique_index(:groups, [:bottom_id])

  end
end
