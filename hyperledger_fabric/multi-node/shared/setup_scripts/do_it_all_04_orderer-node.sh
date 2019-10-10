#!/bin/bash


echo "###########################################"
echo "===> Register orderer node...."
echo "###########################################"
./09_enroll_orderer-node.sh orderer-node 
sleep 3

echo "###########################################"
echo "===>  Starting orderer node...." 
echo "###########################################"
./10_start_orderer.sh
sleep 2
