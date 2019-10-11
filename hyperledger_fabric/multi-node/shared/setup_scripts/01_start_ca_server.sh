#!/bin/bash

# Starts the CA server
echo "-----------------------------------------------------------------------------------------"
echo "Starting CA-Server"
echo "-----------------------------------------------------------------------------------------"
killall fabric-ca-server 2> /dev/null
echo "checking $FABRIC_CA_SERVER_HOME/$FABRIC_CA_SERVER_CONFIG_FILE"

if [ -f "$FABRIC_CA_SERVER_HOME/$FABRIC_CA_SERVER_CONFIG_FILE" ]
then   
    echo "Using $FABRIC_CA_SERVER_HOME/$FABRIC_CA_SERVER_CONFIG_FILE"
else
    echo "Server YAML not found in $FABRIC_CA_SERVER_HOME/"
    mkdir -p $FABRIC_CA_SERVER_HOME
    echo "Copying $BASE_CONFIG_FILES/$FABRIC_CA_SERVER_CONFIG_FILE to $FABRIC_CA_SERVER_HOME "
    cp $BASE_CONFIG_FILES/$FABRIC_CA_SERVER_CONFIG_FILE  $FABRIC_CA_SERVER_HOME
fi

echo "Starting server with: $FABRIC_CA_SERVER_HOME/$FABRIC_CA_SERVER_CONFIG_FILE"

cd $FABRIC_CA_SERVER_HOME
fabric-ca-server start 2> $FABRIC_CA_SERVER_LOG &

sleep 3
echo "Server Started ... Logs available at $FABRIC_CA_SERVER_LOG"
echo "---------------------------- $FABRIC_CA_SERVER_LOG -----------------------------------"
cat $FABRIC_CA_SERVER_LOG
echo "---------------------------- $FABRIC_CA_SERVER_LOG -----------------------------------"