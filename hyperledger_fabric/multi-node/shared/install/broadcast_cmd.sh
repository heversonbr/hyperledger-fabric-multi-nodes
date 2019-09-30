#!/bin/bash
# TODO : remove localhost from the list  , remove this script!

ALLHOSTS="msp-root1-org1 msp-admin-org1 msp-admin-org2 ordering-0 peer1-org1 peer2-org1"

for host in $ALLHOSTS; do 
    echo "-----------------------------------" 
    echo "Broadcasting cmd to: $host"
    echo "-----------------------------------" 
    ssh StrictHostKeyChecking no ubuntu@$host  "ls"


done

echo "-----------------------------------" 
echo "Done.
echo "-----------------------------------" 