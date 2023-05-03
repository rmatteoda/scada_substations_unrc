defmodule ScadaSubstationsUnrc.Domain.Substations do
  @moduledoc false
  require Logger

  import Ecto.Query, warn: false

  alias ScadaSubstationsUnrc.Domain.Repo
  alias ScadaSubstationsUnrc.Domain.Substation

  def create_substation(substation_name) do
    # TODO validate if exist before create
    %Substation{}
    |> Substation.changeset(%{name: substation_name})
    |> Repo.insert()
  end

  def create_config_substations(substations) do
    Enum.each(substations, fn substation -> create_substation(substation.name) end)
  end

  def get_substation_by_name do
  end

  @doc """
  Return all collected data from substation
  """
  def find_collected_by_subid(_substation_id, :last_week) do
    # query = from dev in SCADAMaster.Schema.MeasuredValues,
    #     where: dev.substation_id == ^substation_id,
    #     where: dev.inserted_at > datetime_add(^NaiveDateTime.utc_now(), -1, "week"),
    #     order_by: [asc: :updated_at],
    #     select: dev

    # ScadaMaster.Repo.all(query, log: false)
  end

  def find_collected_by_subid(_substation_id, :all) do
    # query = from dev in SCADAMaster.Schema.MeasuredValues,
    #     where: dev.substation_id == ^substation_id,
    #     order_by: [asc: :updated_at],
    #     select: dev

    # ScadaMaster.Repo.all(query, log: false)
  end
end
