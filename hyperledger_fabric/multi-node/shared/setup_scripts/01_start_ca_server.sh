#!/bin/bash

# Starts the CA server

killall fabric-ca-server 2> /dev/null
echo "checking $FABRIC_CA_SERVER_HOME/$FABRIC_CA_SERVER_CONFIG"

if [ -f "$FABRIC_CA_SERVER_HOME/$FABRIC_CA_SERVER_CONFIG" ]
then   
    echo "Using $FABRIC_CA_SERVER_HOME/$FABRIC_CA_SERVER_CONFIG"
else
    echo "Server YAML not found in $FABRIC_CA_SERVER_HOME/"
    mkdir -p $FABRIC_CA_SERVER_HOME
    echo "Copying $FABRIC_CONFIG_FILES/$FABRIC_CA_SERVER_CONFIG to $FABRIC_CA_SERVER_HOME "
    cp $FABRIC_CONFIG_FILES/$FABRIC_CA_SERVER_CONFIG  $FABRIC_CA_SERVER_HOME
fi

echo "Starting server with: $FABRIC_CA_SERVER_HOME/$FABRIC_CA_SERVER_CONFIG"

cd $FABRIC_CA_SERVER_HOME
fabric-ca-server start 2> $FABRIC_CA_SERVER_LOG &

sleep 2
echo "Server Started ... Logs available at $FABRIC_CA_SERVER_LOG"
echo "---------------------------- $FABRIC_CA_SERVER_LOG -----------------------------------"
cat $FABRIC_CA_SERVER_LOG