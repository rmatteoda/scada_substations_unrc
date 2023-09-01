defmodule ScadaSubstationsUnrc.Domain.Substations do
  @moduledoc false
  require Logger

  import Ecto.Query, warn: false

  alias ScadaSubstationsUnrc.Domain.MeasuredValues
  alias ScadaSubstationsUnrc.Domain.Repo
  alias ScadaSubstationsUnrc.Domain.Substation

  def create_substation(substation_attrs) do
    %Substation{}
    |> Substation.changeset(substation_attrs)
    |> Repo.insert()
  end

  def add_substations(substations) do
    Enum.each(substations, fn substation_attrs ->
      case get_substation_by_name(substation_attrs.name) do
        {:ok, substation} -> update_substation(substation, substation_attrs)
        {:error, :substation_not_found} -> create_substation(substation_attrs)
      end
    end)
  end

  @spec get_substation_by_name(any) ::
          {:error, :substation_not_found} | {:ok, Substation.t()}
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

  @spec list :: [Substation.t()]
  def list do
    Repo.all(Substation)
  end

  @spec update_substation(substation :: Substation.t(), attrs :: map) ::
          {:ok, Substation.t()} | {:error, Ecto.Changeset.t()}
  def update_substation(%Substation{} = substation, attrs) do
    substation
    |> Substation.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_by_name(String.t()) ::
          {:ok, Substation.t()} | {:error, Ecto.Changeset.t() | :substation_not_found}
  def delete_by_name(substation_name) do
    case get_substation_by_name(substation_name) do
      {:ok, substation} -> delete(substation)
      {:error, :substation_not_found} -> {:error, :substation_not_found}
    end
  end

  @spec delete(substation :: Substation.t()) ::
          {:ok, Substation.t()} | {:error, Ecto.Changeset.t()}
  def delete(%Substation{} = substation) do
    Repo.delete(substation)
  end

  @doc """
  Save collected data from substation into measured_values table
  """
  @spec storage_collected_data(substation :: Substation.t(), collected_values :: map) ::
          {:ok, MeasuredValues.t()} | {:error, Ecto.Changeset.t()}
  def storage_collected_data(substation, collected_values) do
    collected_for = Map.put(collected_values, :substation_id, substation.id)

    %MeasuredValues{}
    |> MeasuredValues.changeset(collected_for)
    |> Repo.insert()
  end

  @doc """
  Return all collected data from substation
  """
  def collected_data(substation_id) do
    from(md in MeasuredValues,
      where: md.substation_id == ^substation_id,
      order_by: [asc: :updated_at],
      select: md
    )
    |> Repo.all()
  end

  def collected_data_in_last_week(substation_id) do
    from(md in MeasuredValues,
      where:
        md.substation_id == ^substation_id and
          md.inserted_at > datetime_add(^NaiveDateTime.utc_now(), -1, "week"),
      order_by: [asc: :updated_at],
      select: md
    )
    |> Repo.all()
  end

  @spec collected_data_from(Ecto.UUID.t(), NaiveDateTime.t()) :: any
  def collected_data_from(substation_id, from_datetime) do
    from(md in MeasuredValues,
      where:
        md.substation_id == ^substation_id and
          md.inserted_at > ^from_datetime,
      order_by: [asc: :updated_at],
      select: md
    )
    |> Repo.all()
  end
end
