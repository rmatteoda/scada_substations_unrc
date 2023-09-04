defmodule ScadaSubstationsUnrc.Worker.SubstationMonitor do
  @moduledoc false
  use GenServer, restart: :transient

  require Logger

  alias ScadaSubstationsUnrc.Worker.PollSubstationWorker

  @default_poll_minutes 20
  # initial time to start polling vivo service after init
  @initial_poll_time 6_000
  # retry timer if poll fail until retries exausted
  @retry_poll_time 30_000

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
    substation = args[:substation]
    Logger.info("[#{__MODULE__}].init with params #{inspect(substation)}.")

    %{
      substation: substation,
      poll_time: poll_time_in_minutes(args[:poll_time]),
      retries: args[:retries],
      attempt: 0,
      disabled?: args[:disabled?] || substation[:disabled]
    }
    |> schedule_next_poll(@initial_poll_time)
  end

  @impl true
  @spec handle_info(:do_poll, map) :: {:noreply, map}
  def handle_info(:do_poll, state) do
    with {:ok, _measured_values} <- PollSubstationWorker.poll_device(state.substation),
         state <- Map.put(state, :attempt, 0),
         {:ok, state} <- schedule_next_poll(state, state.poll_time) do
      {:noreply, state}
    else
      reason ->
        Logger.error(
          "[#{__MODULE__}].handle_info Could no process due some error: #{inspect(reason)}"
        )

        {:ok, state_attempt} =
          Map.update(state, :attempt, 0, fn attempt -> attempt + 1 end)
          |> schedule_next_poll(@retry_poll_time)

        {:noreply, state_attempt}
    end
  end

  # if disabled we are not going to schedule poll work
  @spec schedule_next_poll(map(), integer()) :: {:ok, map}
  defp schedule_next_poll(%{disabled?: true} = state, _poll_time), do: {:ok, state}

  # re-schedule next X minutes to do next job after retry exausted
  defp schedule_next_poll(state, _poll_time) when state.attempt > state.retries do
    Logger.warning(
      "[#{__MODULE__}] Pooler retries exhausted when trying to read data from substation #{inspect(state)}"
    )

    # on retries exhausted, save failed default data to measured registers (0.0)
    PollSubstationWorker.save_failed_connect_device(state.substation)

    # reset attempt and schedule with configured sleet time
    Process.send_after(self(), :do_poll, state.poll_time)
    {:ok, Map.put(state, :attempt, 0)}
  end

  # We schedule the work to happen in X minutes (written in milliseconds).
  defp schedule_next_poll(state, poll_time) do
    Process.send_after(self(), :do_poll, poll_time)
    {:ok, state}
  end

  # We schedule the work to happen in X minutes (written in milliseconds).
  defp poll_time_in_minutes(minutes) when minutes > 0, do: minutes * 60 * 1000
  defp poll_time_in_minutes(_minutes), do: @default_poll_minutes * 60 * 1000
end
