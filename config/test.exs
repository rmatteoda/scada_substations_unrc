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

# config SubstationMonitor that will be getting the values from device in each substation
config :scada_substations_unrc, :monitor, disabled?: true

config :scada_substations_unrc, Oban, testing: :inline
