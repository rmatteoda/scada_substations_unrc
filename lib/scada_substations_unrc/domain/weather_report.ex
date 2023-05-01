defmodule ScadaSubstationsUnrc.Domain.WeatherReport do
  @moduledoc false
  require Logger

  import Ecto.Query

  @doc """
  Return all weather data from last week
  """
  def find_weather_data(:all) do
    # query = from weather in SCADAMaster.Schema.Weather,
    #     order_by: [asc: :updated_at],
    #     select: weather

    # ScadaMaster.Repo.all(query, log: false)
  end

  def find_weather_data(:last_week) do
    # query = from weather in SCADAMaster.Schema.Weather,
    #     where: weather.inserted_at > datetime_add(^NaiveDateTime.utc_now(), -1, "week"),
    #     order_by: [asc: :updated_at],
    #     select: weather

    # ScadaMaster.Repo.all(query, log: false)
  end
end
