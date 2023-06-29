# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

# General application configuration
config :scada_substations_unrc,
  ecto_repos: [ScadaSubstationsUnrc.Domain.Repo],
  namespace: ScadaSubstationsUnrc,
  env: config_env()

# configure ip of diferent device connected to substation to be monitored.
config :scada_substations_unrc, :device_table, [
  %{ip: "192.168.0.5", name: "sub_anf", disabled: false},
  %{ip: "192.168.0.6", name: "sub_jardin", disabled: false},
  %{ip: "192.168.0.7", name: "sub_arte", disabled: false},
  %{ip: "192.168.0.9", name: "sub_biblio", disabled: false}
]

# logger config with file rotation, new feature on Elixir 1.15
config :logger, :default_handler, level: :debug, format: "$time [$level] $message\n"

config :logger, :default_handler,
  config: [
    file: ~c"./log/system.log",
    filesync_repeat_interval: 2000,
    file_check: 2000,
    # 10 mega
    max_no_bytes: 10_000_000,
    max_no_files: 4,
    compress_on_rotate: true
  ]

# config time for to collect data from substations (recommended 10 minutes)
config :scada_substations_unrc, ScadaSubstationsUnrc,
  # 2 horas
  report_after: 2 * 60 * 60 * 1000,
  # 10 horas
  report_path: "/home/ramiro/Documents/UNRC/scada_substations_unrc/tmp"

# config SubstationMonitor that will be getting the values from device in each substation
config :scada_substations_unrc, :monitor,
  disabled?: false,
  # sleep time is in minutes, so, the PollScheduller will run each x minutes
  poll_time: 10,
  # number of retry if the poll server fail
  retries: 4

# config Oban to run cron jobs
config :scada_substations_unrc, Oban,
  repo: ScadaSubstationsUnrc.Domain.Repo,
  plugins: [
    Oban.Plugins.Pruner,
    {Oban.Plugins.Cron,
     crontab: [
       # Configure oban cron job to run each hour
       {"0 * * * *", ScadaSubstationsUnrc.Workers.WeatherObanWorker,
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
       {"0 * * * *", ScadaSubstationsUnrc.Workers.ReportsObanWorker},
       {"* * * * *", ScadaSubstationsUnrc.Workers.EmailObanWorker}
     ]}
  ],
  queues: [default: 10]

# config/config.exs
config :scada_substations_unrc, ScadaSubstationsUnrc.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: "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"

# Configures Elixir's Logger
# config :logger, :console, format: "$time $metadata[$level] $message\n"

# logger configuration
# config :logger,
#   backends: [
#     {LoggerFileBackend, :info_log},
#     {LoggerFileBackend, :debug_log},
#     {LoggerFileBackend, :error_log}
#   ]

# config :logger, :info_log,
#   path: "log/info.log",
#   level: :info

# config :logger, :debug_log,
#   path: "log/debug.log",
#   level: :debug

# config :logger, :error_log,
#   path: "log/error.log",
#   level: :error

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
