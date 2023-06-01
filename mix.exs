defmodule ScadaSubstationsUnrc.MixProject do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :scada_substations_unrc,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {ScadaSubstationsUnrc.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2"},
      {:swoosh, "~> 1.3"},
      {:ecto_psql_extras, "~> 0.7.10"},
      {:oban, "~> 2.14"},

      # Others
      {:logger_json, "~> 5.1"},
      {:timex, "~> 3.7"},
      {:decorator, "~> 1.4"},
      {:elixir_uuid, "~> 1.2"},
      {:httpoison, "~> 1.8"},
      {:tesla, "~> 1.4"},
      {:csvlixir, "~> 2.0.3"},

      # Code quality and testing
      {:credo, "~> 1.6", runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.28", only: :dev, runtime: false},

      # Tesla adapter
      {:hackney, "~> 1.18"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
