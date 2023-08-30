## TODO task

- Add test (unit, integration, smoke and loadtest) to achive coverages
- Search another option for modbus lib (https://github.com/samuelventura/modbus)
- Improve README and documentation
- Add monitoring and trace (grafana/ prometheus, https://akoutmos.com/post/prometheus-postgis-and-phoenix-two)
- deploy app with docker compose
  - some sample https://github.com/akoutmos/prom_ex/blob/master/example_applications/web_app/run_docker_stack.sh
  
## some comands
ScadaSubstationsUnrc.Clients.ImportCsvData.import_historical_data("/home/fernando/scada/reports/historical_reports","sub_jardin")
{:ok, sub} = ScadaSubstationsUnrc.Domain.Substations.get_substation_by_name("sub_jardin")
length(ScadaSubstationsUnrc.Domain.Substations.collected_data(sub.id))
