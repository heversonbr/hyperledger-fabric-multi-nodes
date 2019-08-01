#!/bin/bash

killall fabric-ca-server 2> /dev/null
if [ $? -eq 0 ]; then
    echo "CA-server killed. config files not removed."
else
    echo "error while killing CA-server, it seems to be running"
fi