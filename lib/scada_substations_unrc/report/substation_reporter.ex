defmodule ScadaSubstationsUnrc.Report.SubstationReporter do
  @moduledoc false

  alias ScadaSubstationsUnrc.Domain.Substations

  require Logger

  # column names array for reports
  @meassured_header [
    "Substation Name",
    "Voltage A",
    "Voltage B",
    "Voltage C",
    "Current A",
    "Current B",
    "Current C",
    "Active Power A",
    "Active Power B",
    "Active Power C",
    "Reactive Power A",
    "Reactive Power B",
    "Reactive Power C",
    "Total Active Power",
    "Total Reactive Power",
    "Unbalance Voltage",
    "Unbalance Current",
    "Date"
  ]

  @doc """
  for each substation report into a csv file data collected for last week
  """
  def dump_weekly_report() do
    Substations.list()
    |> Enum.each(fn substation ->
      dump_report(substation)
    end)
  end

  defp dump_report(substation) do
    Substations.collected_data_in_last_week(substation.id)
    IO.inspect(label: "DUMP substation_data:::")
    |> dump_to_csv(substation.name, "_last_week.csv")
  end

  defp dump_to_csv([], _substation_name, _end_filename), do: nil

  defp dump_to_csv(substation_data, substation_name, end_filename) do
    file_name = Path.join(report_path(), substation_name <> end_filename)
    f = File.open!(file_name, [:write, :utf8])
    IO.inspect(file_name, label: "DUMP file_name:::")

    IO.write(f, CSVLixir.write_row(@meassured_header))

    Enum.each(substation_data, fn measured_values ->
      IO.write(
        f,
        CSVLixir.write_row([
          substation_name,
          measured_values.voltage_a,
          measured_values.voltage_b,
          measured_values.voltage_c,
          measured_values.current_a,
          measured_values.current_b,
          measured_values.current_c,
          measured_values.activepower_a,
          measured_values.activepower_b,
          measured_values.activepower_c,
          measured_values.reactivepower_a,
          measured_values.reactivepower_b,
          measured_values.reactivepower_c,
          measured_values.totalactivepower,
          measured_values.totalreactivepower,
          measured_values.unbalance_voltage,
          measured_values.unbalance_current,
          NaiveDateTime.to_string(measured_values.inserted_at)
        ])
      )
    end)

    File.close(f)
  end

  defp report_path do
    Application.get_env(:scada_substations_unrc, ScadaMaster)
    |> Keyword.fetch!(:report_path)
  end
end
