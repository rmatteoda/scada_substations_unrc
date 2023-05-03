defmodule ScadaSubstationsUnrc.Worker.PollSubstationWorker do
  @moduledoc false

  require Logger

  def poll_device(%{ip: _substation_id, name: _substation_name} = substation) do
    {:ok, substation}
  end
end
