import Config

# configure ip of diferent device connected to substation to be monitored.
config :scada_substations_unrc, :device_table, [
  %{
    ip: "192.168.0.5",
    name: "sub_anf",
    location: "Anfiteatro",
    description: "Anfiteatro",
    disabled: false
  },
  %{
    ip: "192.168.0.6",
    name: "sub_jardin",
    location: "Jardin",
    description: "Jardin",
    disabled: true
  },
  %{ip: "192.168.0.7", name: "sub_arte", location: "Arte", description: "Arte", disabled: false},
  %{
    ip: "192.168.0.9",
    name: "sub_biblio",
    location: "Biblioteca",
    description: "Biblioteca",
    disabled: true
  }
]

# config Oban to run cron jobs
config :scada_substations_unrc, Oban,
  repo: ScadaSubstationsUnrc.Domain.Repo,
  plugins: [
    Oban.Plugins.Pruner,
    {Oban.Plugins.Cron,
     crontab: [
       # Configure weather pooler to run each hour
       {"0 * * * *", ScadaSubstationsUnrc.Workers.WeatherObanWorker,
        args: %{
          # param to use weather stack client
          client: ScadaSubstationsUnrc.Clients.WeatherStackClient,
          weather_service_url: "http://api.weatherstack.com/current",
          access_key: "e08eb75ade286ed290fbc7a414c6e50c"
        }},
       # Configure csv reporter to run hour
       {"0 * * * *", ScadaSubstationsUnrc.Workers.ReportsObanWorker},
       # Configure email reporter to run At 13:00, only on Friday
       {"0 13 * * FRI", ScadaSubstationsUnrc.Workers.EmailObanWorker}
     ]}
  ],
  queues: [default: 10]

# logger config with file rotation, new feature on Elixir 1.15
config :logger, :default_handler, level: :info, format: "$time [$level] $message\n"

config :logger, :default_handler,
  config: [
    file: "/home/ramiro/Workspaces/UNRC/scada_substations_unrc/log/system.log",
    filesync_repeat_interval: 2000,
    file_check: 2000,
    # 10 mega
    max_no_bytes: 10_000_000,
    max_no_files: 4,
    compress_on_rotate: true
  ]
