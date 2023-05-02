defmodule ScadaSubstationsUnrc.Domain.Repo.Migrations.CreateSubstationsTable do
  use Ecto.Migration

  def change do
    create table(:substations, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add :name, :string, size: 40, null: false, unique: true

      timestamps()
    end

    create unique_index(:substations, [:name])
  end
end
