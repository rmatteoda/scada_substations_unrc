defmodule ScadaSubstationsUnrc.Domain.WeatherReport do
  @moduledoc false
  require Logger

  import Ecto.Query, warn: false

  alias ScadaSubstationsUnrc.Domain.Repo
  alias ScadaSubstationsUnrc.Domain.Weather

  @doc """
  Save collected data from weather api http://openweathermap.org
  """
  def create(weather_values \\ %{}) do
    %Weather{}
    |> Weather.changeset(weather_values)
    |> Repo.insert()
  end

  @doc """
  Return all weather data or last week
  """
  def get_weather_data(:all) do
    from(weather in Weather,
      order_by: [asc: :updated_at],
      select: weather
    )
    |> Repo.all()
  end

  def get_weather_data(:last_week) do
    from(weather in Weather,
      where: weather.inserted_at > datetime_add(^NaiveDateTime.utc_now(), -1, "week"),
      order_by: [asc: :updated_at],
      select: weather
    )
    |> Repo.all()
  end
end
