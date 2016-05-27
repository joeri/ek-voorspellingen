defmodule EcPredictions.Repo.Migrations.CreateFavourite do
  use Ecto.Migration

  def change do
    create table(:favourites) do
      add :user_id, references(:users, on_delete: :nothing)
      add :country_id, references(:countries, on_delete: :nothing)

      timestamps
    end
    create index(:favourites, [:user_id])
    create index(:favourites, [:country_id])

  end
end
