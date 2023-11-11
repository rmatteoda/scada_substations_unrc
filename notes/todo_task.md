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
https://platzi.com/tutoriales/100-postgresql-2017/2252-como-generar-una-backup-de-postgresql-y-como-restaurarla/

generar backup:
pg_dump -U postgres -W -h localhost -p 5432 scada_unrc_prod > scada_unrc_prod_backup_11032023.sql

restaurar desde el backup con psql:

optional create db con otro nombre por las dudas que el anterior con error no se creo bien:

sudo --login --user=postgres psql
CREATE DATABASE scada_unrc_prod_bk

restaruar desde el archivo de backup a la db creada anteriormente:
psql -U postgres -W -h localhost -p 5432 -f scada_unrc_prod_backup_11032023.sql -d scada_unrc_prod_bk

verificar con psql:
de la siguiente query optenes el id de una substation por ejemplo la de sub_anf

SELECT s0."id", s0."name" FROM "substations" AS s0 WHERE s0."name" = 'sub_anf';

con el id lo reemplazas donde dice SUB_ID y obtenes todos los valores por ejemplo, te va a tirar un monton pero con eso ya confirmas que se cargo todo

SELECT m0."id", m0."substation_id", m0."voltage_a", m0."voltage_b", m0."voltage_c", m0."current_a", m0."current_b", m0."current_c", m0."activepower_a", m0."activepower_b", m0."activepower_c", m0."reactivepower_a", m0."reactivepower_b", m0."reactivepower_c", m0."totalactivepower", m0."totalreactivepower", m0."unbalance_voltage", m0."unbalance_current", m0."inserted_at", m0."updated_at" FROM "measured_values" AS m0 WHERE (m0."substation_id" = 'SUB_ID') ORDER BY m0."updated_at";

podes ver la cantidad de entradas tambien, para confirmar mas facil
SELECT count(*) FROM "measured_values" AS m0 WHERE m0."substation_id" = 'SUB_ID';
