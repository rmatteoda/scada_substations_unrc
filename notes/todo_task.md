## TODO task

- Add test (unit, integration, smoke and loadtest) to achive coverages
- Search another option for modbus lib (https://github.com/samuelventura/modbus)
- Improve README and documentation
- Add monitoring and trace (grafana/ prometheus, https://akoutmos.com/post/prometheus-postgis-and-phoenix-two)
- deploy app with docker compose
  - some sample https://github.com/akoutmos/prom_ex/blob/master/example_applications/web_app/run_docker_stack.sh

## Added scada.service

https://www.baeldung.com/linux/run-command-start-up

## backup db
pg_dump -U postgres -W -h localhost:5432 scada_unrc_prod > scada_unrc_prod_backup_11032023.sql
https://platzi.com/tutoriales/100-postgresql-2017/2252-como-generar-una-backup-de-postgresql-y-como-restaurarla/