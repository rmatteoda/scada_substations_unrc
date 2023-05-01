defmodule ScadaSubstationsUnrc.Domain.Repo.Migrations.CreateWeatherTable do
  use Ecto.Migration

  def change do
    #we save the weather data from openweather api
    create table(:weather, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add :temp, :float
      add :humidity,   :float
      add :pressure,   :float
      add :wind_speed, :float
      add :cloudiness, :string

      timestamps()
    end
  end
end
