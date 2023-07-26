defmodule ScadaSubstationsUnrc.Domain.Repo.Migrations.AddRefSubstation do
  use Ecto.Migration

  def change do
    alter table("measured_values") do
      modify(:substation_id, references(:substations, type: :uuid))
    end
  end
end
