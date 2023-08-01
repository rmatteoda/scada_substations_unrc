defmodule ScadaSubstationsUnrc.Report.SubstationReporter do
  @moduledoc false

  alias ScadaSubstationsUnrc.Domain.Substations
  alias ScadaSubstationsUnrc.Report.Files
  alias NimbleCSV.RFC4180, as: CSVParser

  require Logger

  # column names array for reports
  @meassured_header [
    "Substation_Name",
    "Voltage_A",
    "Voltage_B",
    "Voltage_C",
    "Current_A",
    "Current_B",
    "Current_C",
    "Active_Power_A",
    "Active_Power_B",
    "Active_Power_C",
    "Reactive_Power_A",
    "Reactive_Power_B",
    "Reactive_Power_C",
    "Total_Active_Power",
    "Total_Reactive_Power",
    "Unbalance_Voltage",
    "Unbalance_Current",
    "Date"
  ]

  @doc """
  for each substation report into a csv file data collected for last week
  """
  def dump_weekly_report do
    Substations.list()
    |> Enum.each(fn substation ->
      dump_report(substation)
    end)
  end

  defp dump_report(substation) do
    Substations.collected_data_in_last_week(substation.id)
    |> dump_to_csv(substation.name)
  end

  defp dump_to_csv([], _substation_name), do: nil

  defp dump_to_csv(substation_data, substation_name) do
    iodata =
      ([@meassured_header] ++ format_values(substation_name, substation_data))
      |> CSVParser.dump_to_iodata()

    Files.report_file_name(substation_name)
    |> File.write!(iodata, [:write, :utf8])
  end

  defp format_values(substation_name, collected_data) do
    collected_data
    |> Enum.map(fn measured_values ->
      [
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
      ]
    end)
  end
end
