defmodule ScadaSubstationsUnrc.Workers.ReportsObanWorker do
  @moduledoc false
  @max_attempts 3

  use Oban.Worker,
    max_attempts: @max_attempts

  require Logger

  @impl Oban.Worker
  @spec perform(Oban.Job.t()) ::
          :ok | {:error, any()}
  def perform(%Oban.Job{
        args: %{"client" => client_module}
      }) do
    # email reports?
    # Logger.info("Report worker, attemp: #{attempt}")
    String.to_existing_atom(client_module)
    |> apply(:dump_weekly_report, [])
  end

  @impl Oban.Worker
  def timeout(_job), do: :timer.seconds(30)
end
