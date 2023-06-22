defmodule ScadaSubstationsUnrc.Workers.WeatherObanWorker do
  @moduledoc false
  @max_attempts 3

  use Oban.Worker,
    max_attempts: @max_attempts

  alias ScadaSubstationsUnrc.Domain.WeatherReport

  require Logger

  # @TODO create client using openweathermap (alternative, some time give wrong values
  # @weather_uri "http://api.openweathermap.org/data/2.5/weather?q=Rio%20Cuarto&appid=ef9b058d47268d7d2e8dd78bcd6e5a0b"

  @impl Oban.Worker
  @spec perform(Oban.Job.t()) ::
          :ok | {:error, :weather_api_response_decode_error | <<_::64, _::_*8>>}
  def perform(%Oban.Job{
        args: %{
          "client" => client_module,
          "weather_service_url" => client_url,
          "access_key" => access_key
        },
        attempt: attempt
      }) do
    Logger.info("Polling weather data with #{client_module}, attemp: #{attempt}")
    poll_weather(client_module, client_url, access_key, attempt)
  end

  @impl Oban.Worker
  def timeout(_job), do: :timer.seconds(30)

  @spec poll_weather(String.t(), String.t(), String.t(), integer()) ::
          :ok | {:error, :weather_api_response_decode_error | <<_::64, _::_*8>>}
  def poll_weather(_client_module, _client_url, _access_key, attempt)
      when attempt >= @max_attempts do
    Logger.error("Polling weather with error, retries exhausted")
    do_save_weather_on_error()
  end

  @doc """
  Call api to get weather info of Rio Cuarto using weatherstack API
  """
  def poll_weather(client, client_url, access_key, _attempt) do
    String.to_existing_atom(client).poll_weather(client_url, access_key)
    # |> apply(:poll_weather, [client_url, access_key])
  end

  # save weather with 0 when there is a connection error
  defp do_save_weather_on_error do
    WeatherReport.create(%{humidity: 0, pressure: 0, temp: 0})
  end
end
