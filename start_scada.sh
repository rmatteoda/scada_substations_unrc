#!/bin/bash

#script to add in init process for linux in order to start collector app on pc startups

#path to app on linux 
#cd "/home/unrc/"
cd "/home/unrc/ScadaMaster/scada/scada_elixir_15/scada_master"

mix run --no-halt

exit 0;

