defmodule ScadaSubstationsUnrc.Report.WeatherReporter do
  @moduledoc false

  alias ScadaSubstationsUnrc.Domain.WeatherReport
  alias ScadaSubstationsUnrc.Report.Files

  require Logger

  # column names array for reports
  @weather_header ["Temperatura", "Presion", "Humedad", "Date"]

  def dump_weekly_report do
    WeatherReport.list_weather_data_last_week()
    |> dump_to_csv()
  end

  defp dump_to_csv([]), do: nil

  defp dump_to_csv(weather_data) do
    f =
      Files.report_file_name("weather")
      |> File.open!([:write, :utf8])

    IO.write(f, CSVLixir.write_row(@weather_header))

    Enum.each(weather_data, fn weather ->
      IO.write(
        f,
        CSVLixir.write_row([
          weather.temp,
          weather.pressure,
          weather.humidity,
          NaiveDateTime.to_string(weather.inserted_at)
        ])
      )
    end)

    File.close(f)
  end
end
