defmodule ScadaSubstationsUnrc.Domain.Substation do
  @moduledoc false

  use ScadaSubstationsUnrc.Domain.Schema

  schema "substations" do
    has_many(:local_measured, ScadaSubstationsUnrc.Domain.MeasuredValues)
    field(:name, :string)
    field(:ip, :string)
    field(:location, :string)
    field(:description, :string)

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(substation, params) do
    substation
    |> cast(params, [:name, :ip, :description, :location])
    |> validate_required([:name, :ip])
    |> validate_length(:ip, min: 6, max: 15)
    |> unique_constraint([:name, :ip])
  end
end
