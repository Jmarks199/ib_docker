#!/usr/bin/bash

Xvfb :0 -ac -screen 0 1024x768x24 &

DISPLAY=:0 /opt/ibc/scripts/displaybannerandlaunch.sh &

# Give enough time for a connection before trying to expose on 0.0.0.0:4003
sleep 30
echo "Forking :::4001 onto 0.0.0.0:4003\n"
socat TCP-LISTEN:4003,fork TCP:127.0.0.1:4001
