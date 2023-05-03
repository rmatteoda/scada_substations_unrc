defmodule ScadaSubstationsUnrc.Worker.SubstationMonitor do
  @moduledoc false
  use GenServer, restart: :transient

  require Logger

  alias ScadaSubstationsUnrc.Worker.PollSubstationWorker

  @default_sleep_hours 24
  # initial time to start polling vivo service after init
  @initial_sleep_time 6_000
  # retry timer if poll fail until retries exausted
  @retry_sleep_time 60_000

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def stop(some_id) do
    GenServer.stop(some_id)
  end

  @doc """
  Callback when the process is initialized.
  """
  @impl true
  @spec init(keyword()) :: {:ok, map()}
  def init(args) do
    Logger.info("SubstationMonitor init #{inspect(args)}.")
    %{
      substation: args[:substation],
      sleep_time: sleep_time_in_hours(args[:sleep_time]),
      retries: args[:retries],
      attempt: 0,
      disabled?: args[:disabled?]
    }
    |> schedule_next_poll(@initial_sleep_time)
  end

  @impl true
  @spec handle_info(:do_poll, map) :: {:noreply, map}
  def handle_info(:do_poll, state) do
    with {:ok, _sub} <- PollSubstationWorker.poll_device(state.substation),
         state <- Map.put(state, :attempt, 0),
         {:ok, state} <- schedule_next_poll(state, state.sleep_time) do
      {:noreply, state}
    else
      reason ->
        Logger.error(
          "[#{__MODULE__}].handle_info Could no process due some error: #{inspect(reason)}"
        )

        {:ok, state_attempt} =
          Map.update(state, :attempt, 0, fn attempt -> attempt + 1 end)
          |> schedule_next_poll(@retry_sleep_time)

        {:noreply, state_attempt}
    end
  end

  # if disabled we are not going to schedule poll work
  @spec schedule_next_poll(map(), integer()) :: {:ok, map}
  defp schedule_next_poll(%{disabled?: true} = state, _sleep_time), do: {:ok, state}

  # re-schedule next X hours to do next job after retry exausted
  defp schedule_next_poll(state, _sleep_time) when state.attempt > state.retries do
    Logger.warning(
      "[#{__MODULE__}] Pooler retries exhausted when trying to read data from substation"
    )

    # reset attempt and schedule with configured sleet time
    Process.send_after(self(), :do_poll, state.sleep_time)
    {:ok, Map.put(state, :attempt, 0)}
  end

  # We schedule the work to happen in X hours (written in milliseconds).
  defp schedule_next_poll(state, sleep_time) do
    Process.send_after(self(), :do_poll, sleep_time)
    {:ok, state}
  end

  # We schedule the work to happen in X hours (written in milliseconds).
  defp sleep_time_in_hours(sleep_hours) when sleep_hours > 0, do: sleep_hours * 60 * 60 * 1000
  defp sleep_time_in_hours(_sleep_hours), do: @default_sleep_hours * 60 * 60 * 1000

  # defp poll_time do
  #   Application.get_env(:scada_master, ScadaSubstationsUnrc)
  #   |> Keyword.fetch!(:poll_time)
  # end
end
