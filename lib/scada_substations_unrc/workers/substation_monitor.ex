defmodule ScadaSubstationsUnrc.Worker.SubstationMonitor do
  @moduledoc false
  use GenServer, restart: :transient

  require Logger

  def start_link(args) do
    Logger.info("SubstationMonitor Starting #{inspect(args)}.")
    GenServer.start_link(__MODULE__, args)
  end

  def stop(some_id) do
    GenServer.stop(some_id)
  end

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl true
  def handle_info(:start, state) do
  end

  defp poll_time do
    Application.get_env(:scada_master, ScadaSubstationsUnrc)
    |> Keyword.fetch!(:poll_time)
  end
end
