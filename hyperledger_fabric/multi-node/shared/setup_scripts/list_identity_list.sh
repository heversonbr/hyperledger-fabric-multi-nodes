#!/bin/bash
echo "-----------------------------"
env | grep FABRIC
echo "-----------------------------"
. ./set-ca-client.sh caserver admin
echo "-----------------------------"
fabric-ca-client identity list
echo "-----------------------------"