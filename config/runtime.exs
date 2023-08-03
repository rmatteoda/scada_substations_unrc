import Config

maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []
env = System.get_env("MIX_ENV", "local_env")

config :scada_substations_unrc, ScadaSubstationsUnrc.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SENDGRID_API_KEY", "XXXXXXXX")

config :scada_substations_unrc, ScadaSubstationsUnrc.Domain.Repo,
  hostname: System.get_env("ECTO_HOST", "localhost"),
  database: "scada_unrc_#{env}",
  username: System.get_env("ECTO_USER", "postgres"),
  password: System.get_env("ECTO_PASS", "postgres"),
  port: System.get_env("ECTO_PORT", "5432") |> String.to_integer(),
  pool_size: System.get_env("ECTO_POOL_SIZE", "10") |> String.to_integer(),
  socket_options: maybe_ipv6

config :scada_substations_unrc, ScadaSubstationsUnrc.PromEx,
  # metrics_server: [
  #   port: 4001
  # ],
  disabled: true,
  manual_metrics_start_delay: :no_delay,
  drop_metrics_groups: [],
  grafana: :disabled,
  metrics_server: :disabled

# grafana: [
#   host: System.get_env("GRAFANA_HOST") || raise("GRAFANA_HOST is required"),
#   username: "1092461",
#   password: "configured",
#   #auth_token: System.get_env("GRAFANA_TOKEN") || raise("GRAFANA_TOKEN is required"),
#   upload_dashboards_on_start: true,
#   folder_name: "ScadaSubstationsUnrc Dashboards",
#   annotate_app_lifecycle: true
# ]

# config :logger, level: :info
