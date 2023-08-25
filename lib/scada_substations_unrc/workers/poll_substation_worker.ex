defmodule ScadaSubstationsUnrc.Worker.PollSubstationWorker do
  @moduledoc false

  require Logger

  alias ScadaSubstationsUnrc.Domain.Substations

  def poll_device(%{ip: substation_ip, name: substation_name} = _substation) do
    with {:ok, substation} <- Substations.get_substation_by_name(substation_name),
         {:ok, collected_values} <- do_read_registers(substation_ip, substation) do
      Substations.storage_collected_data(substation, collected_values)
    else
      {:error, :failed_connect} ->
        {:error, :failed_connect}

      {:error, reason} ->
        Logger.error("Error poll substation #{substation_name}: #{inspect(reason)}")
        {:error, reason}
    end
  end

  @doc """
  Save 0.0 to all values when conenction failed
  """
  def save_failed_connect_device(%{name: substation_name} = _substation) do
    with {:ok, substation} <- Substations.get_substation_by_name(substation_name),
         {:ok, failled_connect_values} <- failed_connect_registers(substation) do
      Substations.storage_collected_data(substation, failled_connect_values)
    else
      {:error, reason} ->
        Logger.error(
          "Error save failled values on substation #{substation_name}: #{inspect(reason)}"
        )

        {:error, reason}
    end
  end

  # Read sempron register using ex_modbus library
  defp do_read_registers(substation_ip, substation) do
    do_connect(substation_ip)
    |> do_read_modbus(substation)
  end

  defp do_read_modbus({_pid, :failed_connect}, _substation) do
    {:error, :failed_connect}
  end

  # buid register map from struc for substation with all offsets and register key defined
  # iterate over map to read all registers
  defp do_read_modbus({pid, connected_status}, substation) do
    substation_values =
      Map.from_struct(ScadaSubstationsUnrc.Domain.MeasureStruct)
      |> Map.new(fn {key, val} ->
        {:ok, val} = do_read_register(pid, val, connected_status)
        {key, val}
      end)
      |> Map.put(:substation_id, substation.id)

    {:ok, substation_values}
  end

  # Read modbus register using the pid of the connection, register offset
  defp do_read_register(pid, register_offset, :connected) do
    # Logger.debug "Reading register on MODBUS "
    response = ExModbus.Client.read_data(pid, 1, register_offset, 2)
    {:read_holding_registers, [modbus_reg_1, modbus_reg_2]} = Map.get(response, :data)

    float_byte1 = modbus_reg_1 |> :binary.encode_unsigned() |> Base.encode16()
    float_byte2 = modbus_reg_2 |> :binary.encode_unsigned() |> Base.encode16()

    <<float_val::size(32)-float>> = Base.decode16!(float_byte1 <> float_byte2)

    {:ok, float_val}
  rescue
    e ->
      Logger.error("exception on read_register: #{inspect(e)}")
      {:ok, 0.0}
  end

  # Create default map with values on connection error (modbus status failed_connect)
  defp failed_connect_registers(substation) do
    substation_values =
      Map.from_struct(ScadaSubstationsUnrc.Domain.MeasureStruct)
      |> Map.new(fn {key, _val} ->
        {key, 0.0}
      end)
      |> Map.put(:substation_id, substation.id)

    {:ok, substation_values}
  end

  defp do_connect(substation_ip) do
    Logger.debug("connecting to #{substation_ip}")
    {:ok, {ip_a, ip_b, ip_c, ip_d}} = substation_ip |> to_charlist() |> :inet_parse.address()

    {:ok, pid} = ExModbus.Client.start_link({ip_a, ip_b, ip_c, ip_d})
    socket_state = ExModbus.Client.socket_state(pid)
    Logger.debug("connected state #{socket_state}")

    {pid, socket_state}
  end
end
