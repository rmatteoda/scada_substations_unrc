defmodule ScadaSubstationsUnrc.Clients.ImportCsvData do
  @moduledoc false

  alias NimbleCSV.RFC4180, as: CSVParser
  alias ScadaSubstationsUnrc.Domain.Substations
  alias ScadaSubstationsUnrc.Report.Files

  require Logger

  @doc """
  Call to import old data from csv report
  """
  def import_historical_data(csv_files_path, substation_name) do
    case Substations.get_substation_by_name(substation_name) do
      {:ok, substation} ->
        insert_historical_data(csv_files_path, substation)

      {:error, reason} ->
        Logger.error("Error poll substation #{substation_name}: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp insert_historical_data(csv_files_path, substation) do
    Files.csv_file(
      csv_files_path,
      substation.name,
      "_all.csv"
    )
    |> File.stream!(read_ahead: 100_000)
    |> CSVParser.parse_stream()
    |> Stream.map(fn [
                       _sub_name,
                       voltage_a,
                       voltage_b,
                       voltage_c,
                       current_a,
                       current_b,
                       current_c,
                       activepower_a,
                       activepower_b,
                       activepower_c,
                       reactivepower_a,
                       reactivepower_b,
                       reactivepower_c,
                       totalactivepower,
                       totalreactivepower,
                       unbalance_voltage,
                       unbalance_current,
                       measure_time
                     ] ->
      historical_collected_values = %{
        substation_id: substation.id,
        voltage_a: String.to_float(voltage_a),
        voltage_b: String.to_float(voltage_b),
        voltage_c: String.to_float(voltage_c),
        current_a: String.to_float(current_a),
        current_b: String.to_float(current_b),
        current_c: String.to_float(current_c),
        activepower_a: String.to_float(activepower_a),
        activepower_b: String.to_float(activepower_b),
        activepower_c: String.to_float(activepower_c),
        reactivepower_a: String.to_float(reactivepower_a),
        reactivepower_b: String.to_float(reactivepower_b),
        reactivepower_c: String.to_float(reactivepower_c),
        totalactivepower: String.to_float(totalactivepower),
        totalreactivepower: String.to_float(totalreactivepower),
        unbalance_voltage: String.to_float(unbalance_voltage),
        unbalance_current: String.to_float(unbalance_current),
        inserted_at: measure_time
      }

      Substations.storage_collected_data(substation, historical_collected_values)
    end)
    |> Stream.run()

    Logger.info("Historical data for substation #{substation.name} was imported into DB")
  end
end
