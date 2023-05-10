defmodule ScadaSubstationsUnrc.Clients.WeatherStackClient do
  alias ScadaSubstationsUnrc.Domain.WeatherReport

  require Logger

  # weather api using weatherstack free plan
  # @weather_uri "http://api.weatherstack.com/current?access_key=e08eb75ade286ed290fbc7a414c6e50c&query=Rio%20Cuarto"

  @doc """
  Call api to get weather info of Rio Cuarto using weatherstack API
  """
  def poll_weather(client_uri, access_key) do
    weather_api_endpoint = endpoint(client_uri, access_key)

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
    IO.inspect(weather_map, label: "MODULE WEATHER CLIENT weather_map::")

    Enum.map(weather_map, fn {key, val} -> convert(String.to_atom(key), val) end)
    |> Map.new()
    |> WeatherReport.create()
  end

  defp do_save_weather(_other), do: {:error, :weather_api_response_decode_error}

  @doc """
  Convert weather values from api to local standars (i.e: convert :temp from kelvin to celcius)
  """
  def convert(k, v) do
    do_convert(k, v)
  end

  defp do_convert(:temperature, v), do: {:temp, v}
  defp do_convert(k, v), do: {k, v}

  defp endpoint(client_uri, access_key),
    do: "#{client_uri}?access_key=#{access_key}&query=Rio%20Cuarto"
end
