#!/bin/bash

# source all environment variables
.  /home/ubuntu/hyperledger_ws/install/fabric.env.sh

echo "--------------------------------------------------------------------------------------"
echo "Checking prereqs with user: $USER"
echo "--------------------------------------------------------------------------------------"

echo "installing for user: $FABRIC_USER"
echo "fabric_home: $HYPERLEDGER_HOME"
echo $GOROOT
echo $GOPATH
echo $PATH 


echo "--------------------------------------------------------------------------------------"
echo "curl:"
curl -V  | grep curl
echo "--------------------------------------------------------------------------------------"
echo "golang:"
go version
echo "--------------------------------------------------------------------------------------"
echo "node.js:"
node --version
echo "--------------------------------------------------------------------------------------"
echo "Python:"
python -V
echo "--------------------------------------------------------------------------------------"
echo "npm:"
sudo npm --version
#echo "--------------------------------------------------------------------------------------"
#docker -v
#echo "--------------------------------------------------------------------------------------"
#docker-compose --version
#echo "--------------------------------------------------------------------------------------"