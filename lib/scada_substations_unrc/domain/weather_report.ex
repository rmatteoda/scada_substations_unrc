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
  Return all weather data
  """
  def list_all_weather_data do
    from(weather in Weather,
      order_by: [asc: :updated_at],
      select: weather
    )
    |> Repo.all()
  end

  @doc """
  Return last week weather data
  """
  def list_weather_data_last_week do
    from(weather in Weather,
      where: weather.inserted_at > datetime_add(^NaiveDateTime.utc_now(), -1, "week"),
      order_by: [asc: :updated_at],
      select: weather
    )
    |> Repo.all()
  end

  @spec list_weather_data_from(NaiveDateTime.t()) :: any
  def list_weather_data_from(from_datetime) do
    from(weather in Weather,
      where: weather.inserted_at > ^from_datetime,
      order_by: [asc: :updated_at],
      select: weather
    )
    |> Repo.all()
  end
end
