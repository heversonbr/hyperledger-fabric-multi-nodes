#!/bin/bash

#sudo apt-get install -y tree 
clear

tail -f /home/ubuntu/hyperledger_ws/fabric/orderer.log | grep -v WARN