defmodule ScadaSubstationsUnrc.Report.Files do
  @moduledoc false

  @doc """
  return the configured file name to save report for last week
  """
  def report_file_name(resource_name, end_file_name \\ "_last_week.csv") do
    Path.join(report_path(), resource_name <> end_file_name)
  end

  defp report_path do
    Application.get_env(:scada_substations_unrc, ScadaSubstationsUnrc)
    |> Keyword.fetch!(:report_path)
  end
end
