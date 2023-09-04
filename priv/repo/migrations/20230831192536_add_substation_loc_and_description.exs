defmodule ScadaSubstationsUnrc.Domain.Repo.Migrations.AddSubstationLocAndDescription do
  use Ecto.Migration

  def change do
    alter table("substations") do
      add :ip, :string, size: 15, unique: true
      add :location, :string, size: 250, unique: true
      add :description, :string
    end
  end
end
