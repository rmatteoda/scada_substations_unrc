defmodule ScadaSubstationsUnrc.Domain.Substation do
  @moduledoc false

  use ScadaSubstationsUnrc.Domain.Schema

  schema "substations" do
    has_many(:local_measured, ScadaSubstationsUnrc.Domain.MeasuredValues)
    field(:name, :string)

    timestamps()
  end

  def changeset(substation, params \\ :empty) do
    substation
    |> cast(params, [:name])
    |> validate_required(:name)
    |> unique_constraint(:name)
  end
end
