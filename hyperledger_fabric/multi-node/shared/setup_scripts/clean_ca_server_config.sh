#!/bin/bash

killall fabric-ca-server 2> /dev/null
echo "tried to stop CA-server ... Logs available at = $FABRIC_CA_SERVER_LOG"

echo "removing config files in $FABRIC_CA_SERVER_HOME"

rm -Rf $FABRIC_CA_SERVER_HOME/*