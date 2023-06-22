defmodule ScadaSubstationsUnrc.Workers.ReportsObanWorker do
  @moduledoc false
  @max_attempts 3

  use Oban.Worker,
    max_attempts: @max_attempts

  require Logger

  alias ScadaSubstationsUnrc.Report.SubstationReporter
  alias ScadaSubstationsUnrc.Report.WeatherReporter

  @impl Oban.Worker
  @spec perform(Oban.Job.t()) ::
          :ok | {:error, any()}
  def perform(%Oban.Job{
        args: _args
      }) do
    Logger.info("Report worker run to dump csv reports with data from last week")
    # generate csv file report of measured values for each substation
    SubstationReporter.dump_weekly_report()

    # generate csv file report of weather data
    WeatherReporter.dump_weekly_report()

    # email reports?
  end

  @impl Oban.Worker
  def timeout(_job), do: :timer.seconds(30)
end
