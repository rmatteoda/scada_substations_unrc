# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

# General application configuration
#config :scada_substations_unrc,
#  ecto_repos: [ScadaSubstationsUnrc.Repo]

# configure ip of diferent device connected to substation to be monitored.
config :scada_substations_unrc, :device_table,
      [%{ip: "192.168.0.5", name: "sub_anf"},
       %{ip: "192.168.0.6", name: "sub_jardin"},
       %{ip: "192.168.0.7", name: "sub_arte"},
       %{ip: "192.168.0.9", name: "sub_biblio"}]

# logger configuration
# config :logger,
#   backends: [{LoggerFileBackend, :debug},
#              {LoggerFileBackend, :error}]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: []

#config time for to collect data from substations (recommended 10 minutes)
config :scada_substations_unrc, ScadaSubstationsUnrc,
  poll_time: 10 * 60 * 1000, # 10 minutes
  report_after: 2 * 60 * 60 * 1000, # 2 horas
  report_email_after: 12 * 60 * 60 * 1000 # 10 horas

# config :scada_substations_unrc, ScadaSubstationsUnrc,
#   report_path: "/home/unrc/reports/"

# Config Email Adapter
# config :scada_substations_unrc, SCADAMaster.Schema.Mailer,
#   adapter: Swoosh.Adapters.SMTP,
#   relay: "smtp.gmail.com",
#   port: 587,
#   username: "metodosunrc@gmail.com",
#   password: "novalematlab",
#   tls: :always,
#   auth: :always

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
