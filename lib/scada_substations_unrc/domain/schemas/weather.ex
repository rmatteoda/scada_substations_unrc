defmodule ScadaSubstationsUnrc.Domain.Weather do
  @moduledoc false

  use ScadaSubstationsUnrc.Domain.Schema

  schema "weather" do
    field(:temp, :float)
    field(:humidity, :float)
    field(:pressure, :float)
    field(:wind_speed, :float)
    field(:cloudiness, :string)
    timestamps()
  end

  @required_fields [:humidity, :pressure, :temp]
  @optional_fields [:cloudiness, :wind_speed]

  def changeset(weather, params \\ :empty) do
    weather
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
  end
end