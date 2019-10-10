#!/bin/bash

echo "###########################################"
echo "===> Starting CA-Server..."
echo "###########################################"
./01_start_ca_server.sh
sleep 3

echo "###########################################"
echo "===> Enrolling bootstrap admin identity...."
echo "###########################################"
./02_enroll_bootstrap_identity.sh
sleep 2

echo "###########################################"
echo "===> Registering org1-admin..."
echo "###########################################"
./03_register_admin.sh client org1-admin    pw org1    org1
sleep 2

echo "###########################################"
echo "===> Registering org2-admin..."
echo "###########################################"
./03_register_admin.sh client org2-admin    pw org2    org2
sleep 2

echo "###########################################"
echo "===> Registering orderer-admin..."
echo "###########################################"
./03_register_admin.sh client orderer-admin pw orderer orderer
echo "###########################################"
echo "===> Done! "
echo "###########################################"

