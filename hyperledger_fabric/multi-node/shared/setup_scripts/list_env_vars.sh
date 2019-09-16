#!/bin/bash

echo "########## LIST ENV VARS ################"
env | grep FABRIC
echo "#########################################"
env | grep ORDERER
echo "#########################################"
env | grep CORE_PEER
echo "#########################################"