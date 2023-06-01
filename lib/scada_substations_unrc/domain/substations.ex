defmodule ScadaSubstationsUnrc.Domain.Substations do
  @moduledoc false
  require Logger

  import Ecto.Query, warn: false

  alias ScadaSubstationsUnrc.Domain.Repo
  alias ScadaSubstationsUnrc.Domain.Substation
  alias ScadaSubstationsUnrc.Domain.MeasuredValues

  def create_substation(substation_name) do
    %Substation{}
    |> Substation.changeset(%{name: substation_name})
    |> Repo.insert()
  end

  def add_substations(substations) do
    Enum.each(substations, fn substation ->
      case get_substation_by_name(substation.name) do
        {:ok, _substation} -> :ok
        {:error, :substation_not_found} -> create_substation(substation.name)
      end
    end)
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

  @spec list :: [Substation.t()]
  def list do
    Repo.all(Substation)
  end

  @spec update(substation :: Substation.t(), attrs :: map) ::
          {:ok, Substation.t()} | {:error, Ecto.Changeset.t()}
  def update(%Substation{} = substation, attrs) do
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
  def storage_collected_data(collected_values) do
    %MeasuredValues{}
    |> MeasuredValues.changeset(collected_values)
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
end
