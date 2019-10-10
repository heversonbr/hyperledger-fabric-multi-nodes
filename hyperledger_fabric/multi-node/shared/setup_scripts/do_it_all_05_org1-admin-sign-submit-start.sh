#!/bin/bash

echo "###########################################"
echo "===> Org1 signing channel TX ..."
echo "###########################################"
./11_sign_channel-tx.sh org1  
sleep 3

echo "###########################################"
echo "===> Org1 submit channel TV ..." 
echo "###########################################"
./12_submit_create_channel.sh  org1  admin 
sleep 2


echo "###########################################"
echo "===> Org1  registering peer1  ..."
echo "###########################################"
./13_peer_register.sh peer1 pw org1
sleep 2 

echo "###########################################"
echo "===> Org1  registering peer2 ..."
echo "###########################################"
./13_peer_register.sh peer2 pw org1
sleep 2 