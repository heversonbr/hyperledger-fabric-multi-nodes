#!/bin/bash

#sudo apt-get install -y tree 
clear

SERVER=false
if [ -d ../ca-server/ ]; then
    SERVER=true
fi

while true; do 
    echo  "##################################"
    hostname
    echo  "##################################"
    if [ $SERVER ]; then
        tree -cD ../ca-server/;
        echo  "##################################"
    fi
    tree -cD ../ca-client/; 
    sleep 3 ; 
    clear; 
done