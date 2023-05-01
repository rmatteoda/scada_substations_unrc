defmodule ScadaSubstationsUnrc.Domain.Substations do
  @moduledoc false
  require Logger

  import Ecto.Query

  def create_substation() do
  end

  def get_substation_by_name do
  end

  @doc """
  Return all collected data from substation
  """
  def find_collected_by_subid(substation_id, :last_week) do
    # query = from dev in SCADAMaster.Schema.MeasuredValues,
    #     where: dev.substation_id == ^substation_id,
    #     where: dev.inserted_at > datetime_add(^NaiveDateTime.utc_now(), -1, "week"),
    #     order_by: [asc: :updated_at],
    #     select: dev

    # ScadaMaster.Repo.all(query, log: false)
  end

  def find_collected_by_subid(substation_id, :all) do
    # query = from dev in SCADAMaster.Schema.MeasuredValues,
    #     where: dev.substation_id == ^substation_id,
    #     order_by: [asc: :updated_at],
    #     select: dev

    # ScadaMaster.Repo.all(query, log: false)
  end
end
