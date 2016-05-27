defmodule EcPredictions.Repo.Migrations.CreateCountry do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :name, :string

      timestamps
    end

  end
end
