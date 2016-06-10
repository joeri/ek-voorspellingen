defmodule EcPredictions.Repo.Migrations.CreateGroup do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string, null: false

      timestamps
    end
    create unique_index(:groups, [:name])

  end
end
