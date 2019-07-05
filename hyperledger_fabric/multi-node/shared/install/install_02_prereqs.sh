#!/bin/bash
# NOTE! fabric pre-reqs are:
# curl tool
# docker and docker-compose
# Go programming language (version 1.10 and above, depending on the Fabric release needed)
# node.js version 8.x
# npm (5.6.0 recommanded)
# python2.7

# source all environment variables
.  /home/ubuntu/hyperledger_ws/install/fabric.env.sh

echo "----------------------------------------------" 
echo "Installing Fabric Pre-requirements" 
echo "installing for user: $FABRIC_USER"
echo "fabric_home: $HYPERLEDGER_HOME"
echo $GOROOT
echo $GOPATH
echo $PATH 
echo "----------------------------------------------" 


# check if environment variables were added into .bashrc , update .bashrc if not! 

grep "source $HYPERLEDGER_HOME/install/fabric.env.sh" /home/$FABRIC_USER/.bashrc
status=$?
if [ $status -eq 0 ]; then 
    echo "found"
    echo "source $HYPERLEDGER_HOME/install/fabric.env.sh already in /home/$FABRIC_USER/.bashrc. Doing nothing!" 
else 
    echo "not found"
    echo "source $HYPERLEDGER_HOME/install/fabric.env.sh" | sudo tee -a /home/$FABRIC_USER/.bashrc
fi
#-----------------------------------------------------
# echo "going into hyperledger workspace..."
cd $HYPERLEDGER_HOME
# enter into HYPERLEDGER_HOME when we log in
grep "cd \$HYPERLEDGER_HOME" /home/$FABRIC_USER/.bashrc
status=$?
if [ $status -eq 0 ]; then 
    echo "found"
    echo "cd $HYPERLEDGER_HOME already in /home/$FABRIC_USER/.bashrc. Doing nothing!" 
else 
    echo "not found"
    echo "cd \$HYPERLEDGER_HOME" | sudo tee -a /home/$FABRIC_USER/.bashrc
fi

echo "----------------------------------------------" 
#----------------------------------------------------------------------------------------------------------
# PRE-REQS HYPERLEDGER
# Check ubuntu version
echo "Checking ubuntu version..."
# try to source lsb-release, if fails get the distrib version using lsb_release command.
UBUNTU_VERSION=`lsb_release -cs`

if [ -z "${UBUNTU_VERSION}" ]; then
    echo "Error: Could not source /etc/lsb-release. Exit";
    exit 1;
fi
echo $UBUNTU_VERSION
# check version is supported
if [ $(lsb_release -cs) = "xenial" ]
then
    echo "Installing prereqs for Ubuntu $UBUNTU_VERSION"
else
    echo "Wrong Ubuntu version! This install works ONLY for xenial"
    exit 1
fi

echo "----------------------------------------------" 
# Updating package lists
sudo apt-get -qq update

echo "----------------------------------------------"
# Curl: Install packages to allow apt to use a repository over HTTPS
sudo apt-get -qq install -y apt-transport-https ca-certificates curl wget gnupg-agent software-properties-common

echo "----------------------------------------------"
# NOTE: check if I really need compose for multinode deployment.
# testing without compose, new type of instalation from etienne's course documentation
#echo "Install the current stable release of Docker Compose..."
#sudo curl -L "https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#echo "Apply executable permissions to the binary..."
#sudo chmod +x /usr/local/bin/docker-compose

echo "----------------------------------------------" 
echo "Installing Golang"
# download the archive
wget -q  https://dl.google.com/go/go1.12.2.linux-amd64.tar.gz || res=$?

if [ ! -z "$res" ]; then
    echo "==> ERROR: There was an error downloading Golang"
    exit 1;
else 
    echo "==> Download finished. uncompressing."
fi

# extract it into /usr/local, creating a Go tree in /usr/local/go 
sudo tar -C /usr/local -xzf go1.12.2.linux-amd64.tar.gz
rm go1.12.2.linux-amd64.tar.gz

# ----------------------------------------------
# Golag variables
# the location where Go package is installed on your system
# export GOROOT="/usr/local/go"
# the export above was removed because it is now done by the file fabric.env.sh sourced in the begining of this file 
# Even though, in Linux, Go’s GOPATH use a default value of $HOME/go, 
# the current Fabric build framework still requires you to set and export that variable, and it must set the GOPATH variable. 
# It must contain only the single directory name for your Go workspace.  (add this to the .bashrc to make it permanent)
# export GOPATH="$HYPERLEDGER_HOME/go" 
# the export above was removed because it is now done by the file fabric.env.sh sourced in the begining of this file 
# extend your command search path to include the Go bin directory
# export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
# the export above was removed because it is now done by the file fabric.env.sh sourced in the begining of this file 
# ----------------------------------------------

echo "----------------------------------------------" 
echo "Install Node.js:  requested for developement only..." 
# Versions other than the 8.x series are not supported at this time
curl -sSL https://deb.nodesource.com/setup_8.x | sudo -E bash -  || res=$?
if [ ! -z "$res" ]; then
    echo "==> ERROR: There was an error downloading Golang"
    exit 1;
fi
echo "----------------------------------------------" 
sudo apt-get -qq install -y nodejs
# installing Node.js will also install NPM, confirm the version of NPM installed:
sudo npm install npm@5.6.0 -g
echo "----------------------------------------------" 
echo "Installing Python"
# The Fabric Node.js SDK requires Python 2.7 in order for npm install operations to complete successfully.
sudo apt-get -qq  install -y python
echo "----------------------------------------------" 
echo "prereqs install Done!"
