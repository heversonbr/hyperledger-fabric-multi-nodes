#!/bin/bash


echo "###########################################"
echo "===> Enrolling orderer admin...."
echo "###########################################"
./04_enroll_admin_and_setup_msp.sh orderer msp-root-org1 192.168.1.10
sleep 3

echo "###########################################"
echo "===> Getting certificates..." 
echo "org1-admin and ca-root certificate...."
echo "###########################################"
./05_get_org-pub-certs.sh org1 
sleep 2


echo "###########################################"
echo "===> Generating genesis block ...."
echo "###########################################"
./06_generate_genesis-block.sh 
sleep 2 


echo "###########################################"
echo "===> Generating channel TX ...."
echo "###########################################"
./07_generate_channel-tx.sh
sleep 3 

echo "###########################################"
echo "===> Registering orderer node...."
echo "###########################################"
./08_register_orderer-node.sh orderer-node
sleep 2 




