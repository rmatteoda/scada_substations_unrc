defmodule ScadaSubstationsUnrc.Clients.OpenWeathermapClient do
  @moduledoc false
  alias ScadaSubstationsUnrc.Domain.WeatherReport

  require Logger

  # weather api using openweathermap client free plan
  # @weather_uri "http://api.openweathermap.org/data/2.5/weather?q=Rio%20Cuarto&appid=ef9b058d47268d7d2e8dd78bcd6e5a0b"

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

  defp do_save_weather({:ok, %{"main" => weather_map}}) do
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
    do: "#{client_uri}?q=Rio%20Cuarto&appid=#{access_key}"
end
