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
  %{ip: "192.168.0.5", name: "sub_anf"},
  %{ip: "192.168.0.6", name: "sub_jardin"},
  %{ip: "192.168.0.7", name: "sub_arte"},
  %{ip: "192.168.0.9", name: "sub_biblio"}
]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: []

# config time for to collect data from substations (recommended 10 minutes)
config :scada_substations_unrc, ScadaSubstationsUnrc,
  # 2 horas
  report_after: 2 * 60 * 60 * 1000,
  # 10 horas
  # report_email_after: 12 * 60 * 60 * 1000,
  report_path: "/home/ramiro/Documents/UNRC/scada_substations_unrc/tmp"

# config SubstationMonitor that will be getting the values from device in each substation
config :scada_substations_unrc, :monitor,
  disabled?: false,
  # sleep time is in minutes, so, the PollScheduller will run each x hours
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
       {"* * * * *", ScadaSubstationsUnrc.Workers.WeatherObanWorker,
        args: %{
          client: ScadaSubstationsUnrc.Clients.WeatherStackClient,
          weather_service_url: "http://api.weatherstack.com/current",
          access_key: "e08eb75ade286ed290fbc7a414c6e50c"
        }},
       {"* * * * *", ScadaSubstationsUnrc.Workers.ReportsObanWorker,
        args: %{
          client: ScadaSubstationsUnrc.Report.SubstationReporter
        }},
       {"* * * * *", ScadaSubstationsUnrc.Workers.ReportsObanWorker,
        args: %{
          client: ScadaSubstationsUnrc.Report.WeatherReport
        }}
     ]}
  ],
  queues: [default: 10]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
