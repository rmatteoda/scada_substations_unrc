import Config

maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

config :scada_substations_unrc, ScadaSubstationsUnrc.Domain.Repo,
  hostname: System.get_env("ECTO_HOST", "localhost"),
  database: "scada_unrc_stage",
  username: System.get_env("ECTO_USER", "postgres"),
  port: System.get_env("ECTO_PORT", "5432") |> String.to_integer(),
  pool_size: System.get_env("ECTO_POOL_SIZE", "10") |> String.to_integer(),
  socket_options: maybe_ipv6
