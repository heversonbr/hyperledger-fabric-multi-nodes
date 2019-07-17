#!/bin/bash

killall fabric-ca-server 2> /dev/null
echo "Server stopped ... Logs available at = $FABRIC_CA_SERVER_LOG"