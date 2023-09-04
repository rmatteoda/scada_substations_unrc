defmodule ScadaSubstationsUnrc.Workers.EmailObanWorker do
  @moduledoc false
  @max_attempts 5

  use Oban.Worker,
    max_attempts: @max_attempts

  require Logger

  alias ScadaSubstationsUnrc.Domain.Substations
  alias ScadaSubstationsUnrc.Mailer
  alias ScadaSubstationsUnrc.Report.BambooEmail
  alias ScadaSubstationsUnrc.Report.Files

  @impl Oban.Worker
  @spec perform(Oban.Job.t()) ::
          :ok | {:error, any()}
  def perform(%Oban.Job{
        args: _args,
        attempt: attempt
      }) do
    Logger.info("Sending csv reports by email (substations and weather), attemp: #{attempt}")

    Substations.list()
    |> Enum.each(fn substation -> do_report_email(substation.name) end)

    send_weather_report()
    :ok
  end

  @impl Oban.Worker
  def timeout(_job), do: :timer.seconds(30)

  defp do_report_email(substation_name) do
    Files.report_file_name(substation_name)
    # Create your email
    |> BambooEmail.csv_report_email(substation_name)
    # Send your email
    |> Mailer.deliver_now()
  end

  defp send_weather_report do
    Files.report_file_name("weather")
    # Create your email
    |> BambooEmail.csv_report_email("weather")
    # Send your email
    |> Mailer.deliver_now()
  end
end
