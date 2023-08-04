defmodule ScadaSubstationsUnrc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias ScadaSubstationsUnrc.HealthcheckPlug

  @impl true
  def start(_type, _args) do
    children = [
      # Capture Prometheus metrics
      ScadaSubstationsUnrc.PromEx,
      # Start the Ecto repository
      ScadaSubstationsUnrc.Domain.Repo,
      # Start the Telemetry supervisor
      # ScadaSubstationsUnrc.Telemetry,
      # Launch the Supervisor for all the substations
      {DynamicSupervisor, strategy: :one_for_one, name: ScadaSubstationsUnrc.DSupervisor},
      # Launch all the monitors for a chain
      {Task, &ScadaSubstationsUnrc.DSupervisor.start_registered_substation/0},
      # Start Cowboy web server
      {Plug.Cowboy,
       scheme: :http, plug: HealthcheckPlug, options: [port: HealthcheckPlug.get_port()]},

      # Starts Oban job processor
      {Oban, Application.fetch_env!(:scada_substations_unrc, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ScadaSubstationsUnrc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
