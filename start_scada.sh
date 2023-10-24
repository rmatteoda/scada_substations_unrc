#!/bin/bash

# script used to start and run scada on startup 
# review under notes how to add this script to run on startup
# path to app on linux 
cd "/home/ramiro/Workspaces/UNRC/scada_substations_unrc"

touch test_service_running_world.sh
make start
exit 0;


