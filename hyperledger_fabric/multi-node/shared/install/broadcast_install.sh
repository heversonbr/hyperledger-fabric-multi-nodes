#!/bin/bash
# TODO : remove localhost from the list
LOCALHOST=`hostname`

for host in `grep Host\   ~/.ssh/config  | cut -d " " -f 2`; do 
    echo $LOCALHOST
    echo $host

    if [ "$host" != "$LOCALHOST" ]; then
        echo "-----------------------------------" 
        echo "Broadcasting installation to: $host"
        echo "-----------------------------------" 
        ssh StrictHostKeyChecking no ubuntu@$host  "/home/ubuntu/hyperledger_ws/install/install_01_docker.sh"
        echo "-----------------------------------" 
        sleep 2
        ssh StrictHostKeyChecking no ubuntu@$host  "/home/ubuntu/hyperledger_ws/install/install_02_prereqs.sh"
        echo "-----------------------------------" 
        sleep 2
        ssh StrictHostKeyChecking no ubuntu@$host  "/home/ubuntu/hyperledger_ws/install/check_prereqs.sh"
        echo "-----------------------------------" 
        sleep 3
        ssh StrictHostKeyChecking no ubuntu@$host  "/home/ubuntu/hyperledger_ws/install/install_03_bootstrap.sh"
        echo "-----------------------------------" 
        sleep 2
        ssh StrictHostKeyChecking no ubuntu@$host  "/home/ubuntu/hyperledger_ws/install/install_04_ca_server.sh"
    else
        echo "-----------------------------------" 
        echo "Skipping local host: $LOCALHOST"
        echo "-----------------------------------" 
    fi 
done

echo "-----------------------------------" 
echo "Installing at local host: $LOCALHOST"
echo "-----------------------------------" 
./install_01_docker.sh
echo "-----------------------------------" 
sleep 2
./install_02_prereqs.sh
echo "-----------------------------------" 
sleep 2
./check_prereqs.sh
echo "-----------------------------------" 
sleep 3
./install_03_bootstrap.sh
echo "-----------------------------------" 
sleep 2
./install_04_ca_server.sh