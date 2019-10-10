#!/bin/bash

echo "###########################################"
echo "===> Peer1 enrolling ..."
echo "###########################################"
./14_peer_enroll.sh peer1 pw org1 msp-admin-org1
sleep 3

echo "###########################################"
echo "===>  Peer1 Starting ..." 
echo "###########################################"
 ./15_start_peer.sh  org1 peer1 192.168.1.15
sleep 2
