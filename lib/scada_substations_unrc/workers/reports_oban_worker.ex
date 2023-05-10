defmodule ScadaSubstationsUnrc.Workers.ReportsObanWorker do
  @moduledoc false
  @max_attempts 3

  use Oban.Worker,
    max_attempts: @max_attempts

  # alias ScadaSubstationsUnrc.Domain.WeatherReport

  require Logger

  @impl Oban.Worker
  @spec perform(Oban.Job.t()) ::
          :ok | {:error, any()}
  def perform(%Oban.Job{
        args: %{"report_type" => _type},
        attempt: attempt
      }) do
    # TODO add config and generate reports
    # csv file weekly reports for each substation
    # csv file weekly reports with weather data
    # email reports?
    Logger.info("Report worker, attemp: #{attempt}")
  end

  @impl Oban.Worker
  def timeout(_job), do: :timer.seconds(30)
end
