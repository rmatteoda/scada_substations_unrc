#!/bin/sh
# echo "Last reboot time: $(date)" > /etc/motd
DATE=$(date +'%F %H:%M:%S')
DIR=/home/ramiro/Documents/UNRC/scada_substations_unrc
echo "Current date and time: $DATE" > $DIR/file1.txt