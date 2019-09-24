#!/bin/bash


killprocess(){

    MYPROC=$1
    echo "Checking for $MYPROC process to kill:"
    ps -ef | grep $MYPROC  | grep -v grep | awk {'print $2'}
    MYPID=`ps -ef | grep $MYPROC  | grep -v grep | awk {'print $2'}`
    if [ -z $MYPID ]; then
        echo "process $MYPROC not found!"
    else
        echo "Found $MYPROC process at id: $MYPID. Killing it."
        sudo kill -9 $MYPID 
        # 2nd check: to be sure. 
        sudo killall $MYPROC 
        echo "checking with: ps -ef | grep $MYPROC..."
        ps -ef | grep $MYPROC
    fi
    echo "-----------------------------------------------------------"
}


killprocess orderer
killprocess peer
killprocess fabric-ca-server



echo "removing config files in $HYPERLEDGER_HOME/fabric/"
rm -Rf $HYPERLEDGER_HOME/fabric/
echo "-----------------------------------------------------------"

echo "removing config files in $BASE_FABRIC_CA_CLIENT_HOME"
rm -Rf $BASE_FABRIC_CA_CLIENT_HOME

echo "-----------------------------------------------------------"
echo "removing config files in $FABRIC_CA_SERVER_HOME"
rm -Rf $FABRIC_CA_SERVER_HOME
echo "-----------------------------------------------------------"
echo "Done."