#!/bin/bash
echo "------------Fabric ENV -----------------"
./list_env_vars.sh
echo "------------Setting HOME ---------------"
SUBDIR=caserver/admin
echo "current FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME=$BASE_FABRIC_CA_CLIENT_HOME/$SUBDIR
echo "now FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
echo "------------Listing Identities----------"
fabric-ca-client identity list
echo "----------------------------------------"