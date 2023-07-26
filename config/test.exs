import Config

# Print only warnings and errors during test
config :logger, level: :warn

config :scada_substations_unrc, ScadaSubstationsUnrc.Domain.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "scada_unrc_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :scada_substations_unrc, :device_table, [
  %{ip: "192.168.0.1", name: "sub_test", disabled: false}
]

# config Oban to run cron jobs
config :scada_substations_unrc, Oban,
  repo: ScadaSubstationsUnrc.Domain.Repo,
  plugins: [
    Oban.Plugins.Pruner,
    {Oban.Plugins.Cron,
     crontab: [
       # Configure jobs to run each hour
       {"0 * * * *", ScadaSubstationsUnrc.Workers.WeatherObanWorker,
        args: %{
          # param to use weather stack client
          client: ScadaSubstationsUnrc.Clients.WeatherStackClient,
          weather_service_url: "http://api.weatherstack.com/current",
          access_key: "e08eb75ade286ed290fbc7a414c6e50c"
        }},
       {"0 * * * *", ScadaSubstationsUnrc.Workers.ReportsObanWorker}
     ]}
  ],
  queues: [default: 10]

# config SubstationMonitor that will be getting the values from device in each substation
config :scada_substations_unrc, :monitor, disabled?: true

config :scada_substations_unrc, Oban, testing: :inline
