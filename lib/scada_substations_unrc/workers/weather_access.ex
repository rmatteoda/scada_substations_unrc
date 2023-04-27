defmodule ScadaSubstationsUnrc.Workers.WeatherAccess do
  @moduledoc false
  use GenServer, restart: :transient

  require Logger

  def start_link(args) do
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
end
