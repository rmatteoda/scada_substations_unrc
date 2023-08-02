import Config

# Configuration for development
config :scada_substations_unrc, ScadaSubstationsUnrc.Domain.Repo,
  hostname: "localhost",
  database: "scada_unrc_dev",
  username: "postgres",
  password: "postgres",
  port: System.get_env("ECTO_PORT", "5432") |> String.to_integer(),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# configure ip of diferent device connected to substation to be monitored.
config :scada_substations_unrc, :device_table, [
  %{ip: "192.168.0.8", name: "sub_dev", disabled: false}
]

# config Oban to run cron jobs
config :scada_substations_unrc, Oban,
  repo: ScadaSubstationsUnrc.Domain.Repo,
  plugins: [
    Oban.Plugins.Pruner,
    {Oban.Plugins.Cron,
     crontab: [
       # Configure weather pooler to run each 2 minutes
       {"*/2 * * * *", ScadaSubstationsUnrc.Workers.WeatherObanWorker,
        args: %{
          # param to use weather stack client
          client: ScadaSubstationsUnrc.Clients.WeatherStackClient,
          weather_service_url: "http://api.weatherstack.com/current",
          access_key: "e08eb75ade286ed290fbc7a414c6e50c"
          # param to use openweathermap client
          # client: ScadaSubstationsUnrc.Clients.OpenWeathermapClient,
          # weather_service_url: "http://api.openweathermap.org/data/2.5/weather",
          # access_key: "ef9b058d47268d7d2e8dd78bcd6e5a0b"
        }},
       # Configure csv reporter  to run each 5 minute
       {"*/5 * * * *", ScadaSubstationsUnrc.Workers.ReportsObanWorker},
       # Configure email reporter to run each 10 minute
       {"*/10 * * * *", ScadaSubstationsUnrc.Workers.EmailObanWorker}
     ]}
  ],
  queues: [default: 10]

config :scada_substations_unrc, :monitor,
  disabled?: false,
  # sleep time is in minutes, so, the PollScheduller will run each x minutes
  poll_time: 1,
  # number of retry if the poll server fail
  retries: 2

# Do not include metadata nor timestamps in development logs
config :logger, format: "$time [$level] $message\n"
