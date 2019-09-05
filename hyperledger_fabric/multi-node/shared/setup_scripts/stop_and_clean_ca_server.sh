#!/bin/bash

killall fabric-ca-server 2> /dev/null

if [ $? -eq 0 ]; then
    echo "CA-server killed."
else
    echo "error while killing CA-server."
fi


echo "removing config files in $FABRIC_CA_SERVER_HOME"
echo "keeping server logs at $FABRIC_CA_SERVER_LOG"

for FILE in `ls $FABRIC_CA_SERVER_HOME/ | grep -v ca-server.log`; do 
    echo "checking $FABRIC_CA_SERVER_HOME/$FILE"
    rm -Rf  $FABRIC_CA_SERVER_HOME/$FILE
    if [ $? -eq 0 ]; then
       echo "removed"
    else
       echo "not removed"
    fi
done

echo "removing config files in $FABRIC_CA_CLIENT_HOME"
rm -Rf $FABRIC_CA_CLIENT_HOME