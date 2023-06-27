defmodule ScadaSubstationsUnrc do
  @moduledoc """
  Documentation for `ScadaSubstationsUnrc`.
  """

  alias ScadaSubstationsUnrc.Domain.Substation
  alias ScadaSubstationsUnrc.Domain.Substations
  alias ScadaSubstationsUnrc.Domain.WeatherReport
  alias ScadaSubstationsUnrc.Report.SubstationReporter
  alias ScadaSubstationsUnrc.Report.WeatherReporter

  require Logger

  @spec substations :: {:ok, [ScadaSubstationsUnrc.Domain.Substation.t()]}
  def substations do
    subs = Substations.list()
    Logger.info("** Substations = #{inspect(subs, pretty: true)}")
    {:ok, subs}
  end

  @spec get_substation_by_name(any) ::
          {:error, :substation_not_found} | {:ok, ScadaSubstationsUnrc.Domain.Substation.t()}
  def get_substation_by_name(substation_name) do
    Substations.get_substation_by_name(substation_name)
  end

  @spec delete_substation(substation :: Substation.t()) ::
          {:ok, Substation.t()} | {:error, Ecto.Changeset.t()}
  def delete_substation(substation) do
    Substations.delete(substation)
  end

  @spec all_collected_data(Ecto.UUID.t()) :: any
  def all_collected_data(substation_id) do
    Substations.collected_data(substation_id)
  end

  @spec collected_data_from(
          Substation.t(),
          pos_integer,
          pos_integer,
          pos_integer,
          non_neg_integer
        ) :: any
  def collected_data_from(substation, year, month, day, hour) do
    {:ok, from_datetime} = NaiveDateTime.new(year, month, day, hour, 0, 0)
    Substations.collected_data_from(substation.id, from_datetime)
  end

  @spec weather_data() :: any
  def weather_data do
    WeatherReport.list_all_weather_data()
  end

  @spec weather_data_from(pos_integer, pos_integer, pos_integer, non_neg_integer) :: any
  def weather_data_from(year, month, day, hour) do
    {:ok, from_datetime} = NaiveDateTime.new(year, month, day, hour, 0, 0)
    WeatherReport.list_weather_data_from(from_datetime)
  end

  @spec weather_data_last_week :: any
  def weather_data_last_week do
    WeatherReport.list_weather_data_last_week()
  end

  @spec dump_weather_weekly_report :: nil | :ok | {:error, atom}
  def dump_weather_weekly_report do
    WeatherReporter.dump_weekly_report()
  end

  @spec dump_substations_weekly_report :: :ok
  def dump_substations_weekly_report do
    SubstationReporter.dump_weekly_report()
  end
end
