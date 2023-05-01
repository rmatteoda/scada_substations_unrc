defmodule ScadaSubstationsUnrc.Domain.Repo.Migrations.CreateMeasuredValuesTable do
  use Ecto.Migration

  def change do
    # measured_values belong to a substation
    create table(:measured_values) do
      add :substation_id, references(:substations)
      add :voltage_a,   :float
      add :voltage_b,   :float
      add :voltage_c,   :float
      add :current_a, :float
      add :current_b, :float
      add :current_c, :float
      add :activepower_a, :float
      add :activepower_b, :float
      add :activepower_c, :float
      add :reactivepower_a, :float
      add :reactivepower_b, :float
      add :reactivepower_c, :float
      add :totalactivepower, :float
      add :totalreactivepower, :float
      add :unbalance_voltage, :float
      add :unbalance_current, :float

      timestamps()
    end
    # We also add an index so we can find substations
    create index(:measured_values, [:substation_id])

    create unique_index(:substations, [:name])
  end
end
