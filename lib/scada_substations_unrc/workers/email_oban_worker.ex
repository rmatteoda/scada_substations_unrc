defmodule ScadaSubstationsUnrc.Workers.EmailObanWorker do
  @moduledoc false
  @max_attempts 3

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
        args: _args
      }) do
    Logger.info("Sending csv report by email for each substation")

    Substations.list()
    |> Enum.each(fn substation -> do_report_email(substation.name) end)
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
end
