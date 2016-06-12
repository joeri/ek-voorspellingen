defmodule EcPredictions.Repo.Migrations.CreateScore do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :points, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create unique_index(:scores, [:user_id])

  end
end
