defmodule ScadaSubstationsUnrc.Workers.WeatherObanWorker do
  @moduledoc false
  @max_attempts 3

  use Oban.Worker,
    max_attempts: @max_attempts

  alias ScadaSubstationsUnrc.Domain.WeatherReport

  require Logger

  # @TODO separeate two clients for each weather api and configure client to use
  # openweathermap (alternative, some time give wrong values
  # @weather_uri "http://api.openweathermap.org/data/2.5/weather?q=Rio%20Cuarto&appid=ef9b058d47268d7d2e8dd78bcd6e5a0b"
  # @expected_fields ~w(weather wind main )

  # weather api using weatherstack free plan
  # @weather_uri "http://api.weatherstack.com/current?access_key=e08eb75ade286ed290fbc7a414c6e50c&query=Rio%20Cuarto"

  @impl Oban.Worker
  @spec perform(Oban.Job.t()) ::
          :ok | {:error, :weather_api_response_decode_error | <<_::64, _::_*8>>}
  def perform(%Oban.Job{
        args: %{"weather_service_url" => client_url, "access_key" => access_key},
        attempt: attempt
      }) do
    weather_api_endpoint = weather_uri(client_url, access_key)
    Logger.info("Polling weather data from #{weather_api_endpoint}, attemp: #{attempt}")
    poll_weather(weather_api_endpoint, attempt)
  end

  @impl Oban.Worker
  def timeout(_job), do: :timer.seconds(30)

  @spec poll_weather(any, any) ::
          :ok | {:error, :weather_api_response_decode_error | <<_::64, _::_*8>>}
  def poll_weather(_weather_api_endpoint, attempt) when attempt >= @max_attempts do
    Logger.error("Polling weather with error, retries exhausted")
    do_save_weather_on_error()
  end

  @doc """
  Call api to get weather info of Rio Cuarto using weatherstack API
  """
  def poll_weather(weather_api_endpoint, _attempt) do
    case HTTPoison.get(weather_api_endpoint) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        do_process_response(body)

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Weather API Call error status_code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Weather API Call error: #{reason}"}
    end
  end

  defp do_process_response(weather_json_response) do
    weather_json_response
    |> Jason.decode()
    |> do_save_weather
  end

  defp do_save_weather({:ok, %{"current" => weather_map}}) do
    Enum.map(weather_map, fn {key, val} -> convert(String.to_atom(key), val) end)
    |> Map.new()
    |> WeatherReport.create()

    # :ok
  end

  defp do_save_weather(_other), do: {:error, :weather_api_response_decode_error}

  # save weather with 0 when there is a connection error
  defp do_save_weather_on_error do
    WeatherReport.create(%{humidity: 0, pressure: 0, temp: 0})
    # :ok
  end

  @doc """
  Convert weather values from api to local standars (i.e: convert :temp from kelvin to celcius)
  """
  def convert(k, v) do
    do_convert(k, v)
  end

  defp do_convert(:temperature, v), do: {:temp, v}
  defp do_convert(k, v), do: {k, v}

  defp weather_uri(client_uri, access_key),
    do: "#{client_uri}?access_key=#{access_key}&query=Rio%20Cuarto"
end
