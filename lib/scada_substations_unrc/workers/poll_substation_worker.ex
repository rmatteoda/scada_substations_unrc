defmodule ScadaSubstationsUnrc.Worker.PollSubstationWorker do
  @moduledoc false

  require Logger

  alias ScadaSubstationsUnrc.Domain.Substations

  def poll_device(%{ip: substation_ip, name: substation_name} = _substation) do
    case do_read_registers(substation_ip, substation_name) do
      {:ok, collected_values} ->
        Substations.storage_collected_data(collected_values)

      {:error, reason} ->
        Logger.error("Error poll device: #{inspect(reason)}")
        {:error, reason}
    end
  end

  # Read sempron register using ex_modbus library
  defp do_read_registers(substation_ip, substation_name) do
    with {pid, status} <- do_connect(substation_ip) do
      # TODO return error or retry if not connected status?
      do_read_modbus(pid, substation_name, status)
    end

    # if ( status != :connected) do
    #   Logger.debug "Reconnecting to #{substation_ip}"
    #   {pid, status} = do_connect(substation_ip)
    # end
  end

  # buid register map from struc for substation with all offsets and register key defined
  # iterate over map to read all registers
  defp do_read_modbus(pid, substation_name, status) do
    substationdata =
      Map.from_struct(ScadaSubstationsUnrc.Domain.MeasureStruct)
      |> Map.new(fn {key, val} ->
        {:ok, val} = do_read_register(pid, val, status)
        {key, val}
      end)

    case Substations.get_substation_by_name(substation_name) do
      {:error, _error} ->
        {:error, "Substation not found in DB to save collected data"}

      {:ok, sub} ->
        substation_values = Map.put(substationdata, :substation_id, sub.id)
        {:ok, substation_values}
    end
  end

  # Read modbus register using the pid of the connection, register offset
  defp do_read_register(pid, register_offset, :connected) do
    # Logger.debug "Reading register on MODBUS "
    try do
      response = ExModbus.Client.read_data(pid, 1, register_offset, 2)
      {:read_holding_registers, [modbus_reg_1, modbus_reg_2]} = Map.get(response, :data)
      # [modbus_reg_1, modbus_reg_2] = [17249, 886]

      float_byte1 = modbus_reg_1 |> :binary.encode_unsigned() |> Base.encode16()
      float_byte2 = modbus_reg_2 |> :binary.encode_unsigned() |> Base.encode16()

      <<float_val::size(32)-float>> = Base.decode16!(float_byte1 <> float_byte2)

      {:ok, float_val}
    rescue
      e ->
        Logger.error("exception on read_register: " <> e)
        {:ok, 0.0}
    end
  end

  # Create default map with values on connection error (nodbus status off)
  defp do_read_register(_pid, _register_offset, :failed_connect) do
    {:ok, 0.0}
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
