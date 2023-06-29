defmodule ScadaSubstationsUnrc.Workers.EmailObanWorker do
  @moduledoc false
  @max_attempts 3

  use Oban.Worker,
    max_attempts: @max_attempts

  require Logger

  alias ScadaSubstationsUnrc.Mailer
  alias ScadaSubstationsUnrc.Report.BambooEmail

  @impl Oban.Worker
  @spec perform(Oban.Job.t()) ::
          :ok | {:error, any()}
  def perform(%Oban.Job{
        args: _args
      }) do
    Logger.info("Send email report worker runing")
    # Create your email
    BambooEmail.report_email()
    # Send your email
    |> Mailer.deliver_now()
  end

  @impl Oban.Worker
  def timeout(_job), do: :timer.seconds(30)
end
