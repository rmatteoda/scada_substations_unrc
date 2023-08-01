# ScadaSubstationsUnrc

# TODO
- read csv files with data from old DB and migrate to new DB
- Search another option for modbus lib
- Add CI/CD for PR
- Improve README and documentation
- Add test
- Replace CSVLixir for a new library  
- migrate DB from one pc to new version
  - https://www.postgresql.org/docs/9.0/migration.html
  - https://stackoverflow.com/questions/1237725/copying-postgresql-database-to-another-server
- Add monitoring app (grafana, prometheus, signoz?) 
  - https://signoz.io/blog/opentelemetry-elixir/
  - https://monika.hyperjump.tech/
  
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `scada_substations_unrc` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:scada_substations_unrc, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/scada_substations_unrc>.

