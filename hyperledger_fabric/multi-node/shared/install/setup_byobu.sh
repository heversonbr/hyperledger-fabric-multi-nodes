#!/bin/bash
mkdir -p /home/ubuntu/.byobu/
cp /home/ubuntu/hyperledger_ws/install/windows.tmux.hlf  /home/ubuntu/.byobu/windows.tmux.hlf
sudo chown ubuntu:ubuntu /home/ubuntu/.byobu/windows.tmux.hlf
echo "run: BYOBU_WINDOWS=hlf byobu"

#TODO: to be ameliorated 
#ps -ef | grep byobu | grep -v color | awk {'print $2'}
##BPID=`ps -ef | grep byobu | grep -v grep  | awk {'print $2'}`
##if [ -z "$BPID" ] ; then 
##echo "BPID: $BPID" 
#    cp /home/ubuntu/hyperledger_ws/install/windows.tmux.hlf  /home/ubuntu/.byobu/windows.tmux.hlf
#    export BYOBU_WINDOWS=hlf
#    byobu
##else
##    echo "There is a byobu process running. Another session must exist"
##    echo "Check with:  ps -ef | grep byobu , or simple attach to the session using byobu command."
##fi
