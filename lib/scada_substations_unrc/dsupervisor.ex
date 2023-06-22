defmodule ScadaSubstationsUnrc.DSupervisor do
  @moduledoc false

  use DynamicSupervisor

  require Logger

  alias ScadaSubstationsUnrc.Domain.Substations
  alias ScadaSubstationsUnrc.Worker.SubstationMonitor

  @doc """
  """
  @spec start_child(atom | %{:type => binary, optional(any) => any}) ::
          :ignore | {:error, any} | {:ok, pid} | {:ok, pid, any}
  def start_child(substation) do
    Logger.info(
      "[#{__MODULE__}.start_child/1] Launching Monitor for Substation #{substation.name}"
    )

    opts = substation_monitor_config()

    DynamicSupervisor.start_child(
      __MODULE__,
      {SubstationMonitor, [substation: substation] ++ opts}
    )
  end

  @doc """
  """
  @spec start_registered_substation :: :ok
  def start_registered_substation do
    substations_list = Application.get_env(:scada_substations_unrc, :device_table)
    # create substation from config table on DB and load from there
    Substations.add_substations(substations_list)
    # start a worker to poll measured value for each substation
    Enum.each(substations_list, fn substation -> start_child(substation) end)
  end

  # ----------------------------------------------------------------------------
  # Module Dynamic Supervisor functions
  # ----------------------------------------------------------------------------

  @doc """
  """
  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @doc """
  """
  @impl DynamicSupervisor
  @spec init(any) ::
          {:ok,
           %{
             extra_arguments: list,
             intensity: non_neg_integer,
             max_children: :infinity | non_neg_integer,
             period: pos_integer,
             strategy: :one_for_one
           }}
  def init(_init_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp substation_monitor_config do
    Application.fetch_env!(:scada_substations_unrc, :monitor)
  end
end
