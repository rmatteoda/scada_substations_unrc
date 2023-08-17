defmodule ScadaSubstationsUnrc.Domain.MeasuredValues do
  @moduledoc false

  use ScadaSubstationsUnrc.Domain.Schema

  alias ScadaSubstationsUnrc.Domain.Substation

  schema "measured_values" do
    belongs_to(:substation, Substation, type: Ecto.UUID)

    field(:voltage_a, :float, default: 0.0)
    field(:voltage_b, :float, default: 0.0)
    field(:voltage_c, :float, default: 0.0)
    field(:current_a, :float, default: 0.0)
    field(:current_b, :float, default: 0.0)
    field(:current_c, :float, default: 0.0)
    field(:activepower_a, :float, default: 0.0)
    field(:activepower_b, :float, default: 0.0)
    field(:activepower_c, :float, default: 0.0)
    field(:reactivepower_a, :float, default: 0.0)
    field(:reactivepower_b, :float, default: 0.0)
    field(:reactivepower_c, :float, default: 0.0)
    field(:totalactivepower, :float, default: 0.0)
    field(:totalreactivepower, :float, default: 0.0)
    field(:unbalance_voltage, :float, default: 0.0)
    field(:unbalance_current, :float, default: 0.0)

    timestamps()
  end

  @required_fields [
    :voltage_a,
    :voltage_b,
    :voltage_c,
    :current_a,
    :current_b,
    :current_c,
    :activepower_a,
    :activepower_b,
    :activepower_c,
    :reactivepower_a,
    :reactivepower_b,
    :reactivepower_c,
    :totalactivepower,
    :totalreactivepower,
    :unbalance_voltage,
    :unbalance_current,
    :substation_id
  ]
  @optional_fields [:inserted_at]

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(measured_value, params) do
    measured_value
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:substation_id)
  end
end
