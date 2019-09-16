#!/bin/bash

echo "removing config files in $BASE_FABRIC_CA_CLIENT_HOME"
rm -Rf $BASE_FABRIC_CA_CLIENT_HOME
mkdir  $BASE_FABRIC_CA_CLIENT_HOME
echo "Done."