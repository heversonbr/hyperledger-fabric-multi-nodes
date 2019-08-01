#!/bin/bash

killall fabric-ca-server 2> /dev/null

rm -Rf $FABRIC_CA_SERVER_HOME
rm -Rf $FABRIC_CA_CLIENT_HOME

mkdir $FABRIC_CA_SERVER_HOME
mkdir  $FABRIC_CA_CLIENT_HOME