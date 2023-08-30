defmodule ScadaSubstationsUnrc.Report.WeatherReporter do
  @moduledoc false

  alias NimbleCSV.RFC4180, as: CSVParser
  alias ScadaSubstationsUnrc.Domain.WeatherReport
  alias ScadaSubstationsUnrc.Report.Files
  alias Timex.Timezone
  alias Timex.Timezone.Local

  require Logger

  # column names for CSV report header
  @weather_header ["Temperatura", "Presion", "Humedad", "Date"]

  def dump_weekly_report do
    WeatherReport.list_weather_data_last_week()
    |> dump_to_csv()
  end

  defp dump_to_csv([]), do: nil

  defp dump_to_csv(weather_data) do
    iodata =
      ([@weather_header] ++ format_values(weather_data))
      |> CSVParser.dump_to_iodata()

    Files.report_file_name("weather")
    |> File.write!(iodata, [:write, :utf8])
  end

  defp format_values(weather_data) do
    weather_data
    |> Enum.map(fn weather ->
      [
        weather.temp,
        weather.pressure,
        weather.humidity,
        # to convert local time (Argentina timezone)
        weather.inserted_at
        |> Timezone.convert(Local.lookup())
        |> DateTime.to_iso8601()
        # weather.inserted_at |> DateTime.add(-3, :hour) |> DateTime.to_string()
        # DateTime.to_string(weather.inserted_at)
      ]
    end)
  end
end
