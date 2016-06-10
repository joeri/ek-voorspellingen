defmodule EcPredictions.Repo.Migrations.CreateCountryGroup do
  use Ecto.Migration

  def change do
    create table(:country_groups) do
      add :country_id, references(:countries, on_delete: :nothing), null: false
      add :group_id, references(:groups, on_delete: :nothing), null: false

      add :rank, :integer, null: false

      timestamps
    end
    create unique_index(:country_groups, [:country_id])
    create unique_index(:country_groups, [:group_id, :rank])

  end
end
