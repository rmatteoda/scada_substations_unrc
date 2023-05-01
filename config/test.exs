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

config :scada_substations_unrc, Oban, testing: :inline
