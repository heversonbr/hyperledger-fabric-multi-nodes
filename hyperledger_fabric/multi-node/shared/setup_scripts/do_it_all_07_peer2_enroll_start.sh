#!/bin/bash

echo "###########################################"
echo "===> Peer2 enrolling ..."
echo "###########################################"
./14_peer_enroll.sh peer2 pw org1 msp-admin-org1
sleep 4

echo "###########################################"
echo "===>  Peer2 Starting ..." 
echo "###########################################"
 ./15_start_peer.sh  org1 peer2 192.168.1.17
sleep 2
