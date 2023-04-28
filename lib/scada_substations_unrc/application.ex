defmodule ScadaSubstationsUnrc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias ScadaSubstationsUnrc.Workers.WeatherAccess

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ScadaSubstationsUnrc.Domain.Repo,
      # Launch the Supervisor for all the substations
      {DynamicSupervisor, strategy: :one_for_one, name: ScadaSubstationsUnrc.DSupervisor},
      # Launch all the monitors for a chain
      {Task, &ScadaSubstationsUnrc.DSupervisor.start_registered_substation/0},
      # Starts weather access worker
      WeatherAccess
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ScadaSubstationsUnrc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
