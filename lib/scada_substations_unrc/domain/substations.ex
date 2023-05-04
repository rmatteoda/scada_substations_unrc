defmodule ScadaSubstationsUnrc.Domain.Substations do
  @moduledoc false
  require Logger

  import Ecto.Query, warn: false

  alias ScadaSubstationsUnrc.Domain.Repo
  alias ScadaSubstationsUnrc.Domain.Substation
  alias ScadaSubstationsUnrc.Domain.MeasuredValues

  def create_substation(substation_name) do
    # TODO validate if exist before create
    %Substation{}
    |> Substation.changeset(%{name: substation_name})
    |> Repo.insert()
  end

  def create_config_substations(substations) do
    Enum.each(substations, fn substation -> create_substation(substation.name) end)
  end

  def get_substation_by_name(substation_name) do
    query =
      Substation
      |> where([sb], sb.name == ^substation_name)

    case Repo.one(query) do
      %Substation{} = substation ->
        {:ok, substation}

      nil ->
        {:error, :substation_not_found}
    end
  end

  @doc """
  Save collected data from substation into measured_values table
  """
  def storage_collected_data(collected_values) do
    %MeasuredValues{}
    |> MeasuredValues.changeset(collected_values)
    |> Repo.insert()
  end

  @doc """
  Return all collected data from substation
  """
  def collected_data(_substation_id, :all) do
    # query = from dev in SCADAMaster.Schema.MeasuredValues,
    #     where: dev.substation_id == ^substation_id,
    #     order_by: [asc: :updated_at],
    #     select: dev

    # ScadaMaster.Repo.all(query, log: false)
  end

  def collected_data_for_last_week(_substation_id, :last_week) do
    # query = from dev in SCADAMaster.Schema.MeasuredValues,
    #     where: dev.substation_id == ^substation_id,
    #     where: dev.inserted_at > datetime_add(^NaiveDateTime.utc_now(), -1, "week"),
    #     order_by: [asc: :updated_at],
    #     select: dev

    # ScadaMaster.Repo.all(query, log: false)
  end
end
