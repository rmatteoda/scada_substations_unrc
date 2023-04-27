# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

# General application configuration
#config :scada_substations_unrc,
#  ecto_repos: [ScadaMaster.Repo]

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

config :logger, :debug,
  path: "log/debug.log",
  level: :debug

config :logger, :error,
  path: "log/error.log",
  level: :error

#config time for to collect data from substations (recommended 10 minutes)
#config :scada_substations_unrc, ScadaMaster,
#  collect_each: 1000 * 60 * 10 # 10 minutes

#config time to save data into csv file (recomended 2 hours)
# config :scada_substations_unrc, ScadaMaster,
#   report_after: 1000 * 60 * 120 # 120 minutes

#config time to send email report with csv file (recomended 12 hours)
# config :scada_substations_unrc, ScadaMaster,
#   report_email_after: 1000 * 60 * 720 #720 12 horas

# config :scada_substations_unrc, ScadaMaster,
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
