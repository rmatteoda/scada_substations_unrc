# Scada Substations UNRC

IoT Service that read power consuption (voltage, current, active_power, reactive_power, total reactive_power and unbalance_voltage) from each substation located in UNRC through modbus connection, generate reports and send periodic emails notification, also it include a weather report to used for analysis wit power consumption and forecast predictions.

### Requirements

Please made sure to have the following dependencies installed in your system

PostgreSQL 12 or higger versions
Elixir 1.15
Erlang 25

### Initial Setup

First make sure to run in order to configure and create DB for each env (dev, prod and test)

```bash
make setup.all
```

Now configure a `.env` file with the keys that would be used both for building and running
copy `.env.example` file to `.env` and update the values

```bash
SENDGRID_API_KEY=COMPLETE_THIS_FIELD_sendgrid_api_key
ECTO_PORT=5430
REPORT_PATH=COMPLETE_THIS_FIELD_path_to_save_report_path
```

### Running

To run the system there is a make command that should be executed. 

```bash
make start
```

In case of want to run in development environment use the following


```bash
make start.dev
```

### App configurations

To be able to retrieve values from modbus device in substation we use a config setting that include each substation that we want to monitor:

```elixir
config :scada_substations_unrc, :device_table, [
  %{ip: "192.168.0.5", name: "sub_anf", disabled: false},
  %{ip: "192.168.0.6", name: "sub_jardin", disabled: false},
  %{ip: "192.168.0.7", name: "sub_arte", disabled: false},
  %{ip: "192.168.0.9", name: "sub_biblio", disabled: false}
]
```

We use Oban Job to generate reports and get weather information form external system, since those are periodic task Oban cron jobs feature is used, in order to update the period of those task, the next configuration should be updated (only cron expresion):

```elixir
config :scada_substations_unrc, Oban,
  repo: ScadaSubstationsUnrc.Domain.Repo,
  plugins: [
    Oban.Plugins.Pruner,
    {Oban.Plugins.Cron,
     crontab: [
       # Configure weather pooler to run each hour
       {"0 * * * *", ScadaSubstationsUnrc.Workers.WeatherObanWorker,
        args: %{
          # param to use weather stack client
          client: ScadaSubstationsUnrc.Clients.WeatherStackClient,
          weather_service_url: "http://api.weatherstack.com/current",
          access_key: "e08eb75ade286ed290fbc7a414c6e50c"
        }},
       # Configure csv reporter to run every day at 9:00 AM
       {"0 9 * * *", ScadaSubstationsUnrc.Workers.ReportsObanWorker},
       # Configure email reporter to run At 13:00, only on Friday
       {"0 13 * * FRI", ScadaSubstationsUnrc.Workers.EmailObanWorker}
     ]}
  ],
  queues: [default: 10]
```

*Other Current Config*

```elixir
config :scada_substations_unrc, ScadaSubstationsUnrc.Domain.Repo,
  hostname: System.get_env("ECTO_HOST", "localhost"),
  database: "scada_unrc_#{env}",
  username: System.get_env("ECTO_USER", "postgres"),
  password: System.get_env("ECTO_PASS", "postgres"),
  port: System.get_env("ECTO_PORT", "5432") |> String.to_integer(),
  pool_size: System.get_env("ECTO_POOL_SIZE", "10") |> String.to_integer(),
  socket_options: maybe_ipv6
```

### Code

To update the code, create a PR to develop env and locaaly check with:


```bash
make check
```

The latest command will check formatting, linting and run dialyzer
### TODO task
- Add test (unit, integration, smoke and loadtest) to achive coverages
- Search another option for modbus lib (https://github.com/samuelventura/modbus)
- Improve README and documentation
- migrate DB from one pc to new version
  - https://www.postgresql.org/docs/9.0/migration.html
  - https://stackoverflow.com/questions/1237725/copying-postgresql-database-to-another-server
- Add monitoring and trace (grafana, prometheus, signoz?)

