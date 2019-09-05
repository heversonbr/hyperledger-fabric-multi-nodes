#!/bin/bash

echo "removing config files in $FABRIC_CA_CLIENT_HOME"
rm -Rf $FABRIC_CA_CLIENT_HOME
mkdir  $FABRIC_CA_CLIENT_HOME
echo "Done."