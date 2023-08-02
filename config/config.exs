# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

# General application configuration
config :scada_substations_unrc,
  ecto_repos: [ScadaSubstationsUnrc.Domain.Repo],
  namespace: ScadaSubstationsUnrc,
  env: config_env()

# Do not include metadata nor timestamps in development logs
config :logger, format: "$time [$level] $message\n"

# config time for to collect data from substations (recommended 10 minutes)
config :scada_substations_unrc, ScadaSubstationsUnrc,
  report_after: 2 * 60 * 60 * 1000,
  report_path: System.get_env("REPORT_PATH", "/home/fernando/scada/scada_substations_unrc/tmp")

# config SubstationMonitor that will be getting the values from device in each substation
config :scada_substations_unrc, :monitor,
  disabled?: false,
  # sleep time is in minutes, so, the PollScheduller will run each x minutes
  poll_time: 10,
  # number of retry if the poll server fail
  retries: 4

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
