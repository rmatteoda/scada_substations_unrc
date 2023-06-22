defmodule ScadaSubstationsUnrc.Report.WeatherReporter do
  @moduledoc false

  alias ScadaSubstationsUnrc.Domain.WeatherReport

  require Logger

  # column names array for reports
  @weather_header ["Temperatura", "Presion", "Humedad", "Date"]

  def dump_weekly_report do
    file_name = Path.join(report_path(), "weather_last_week.csv")

    WeatherReport.list_weather_data_last_week()
    |> dump_to_csv(file_name)
  end

  defp dump_to_csv([], _filename), do: nil

  defp dump_to_csv(weather_data, file_name) do
    f = File.open!(file_name, [:write, :utf8])
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

  defp report_path do
    Application.get_env(:scada_substations_unrc, ScadaSubstationsUnrc)
    |> Keyword.fetch!(:report_path)
  end
end
