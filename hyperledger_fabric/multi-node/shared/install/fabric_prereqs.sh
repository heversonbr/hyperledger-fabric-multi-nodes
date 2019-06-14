#!/bin/bash

# fabric pre-reqs:
# curl tool
# docker and docker-compose
# Go programming language (version 1.10 and above, depending on the Fabric release needed)
# node.js version 8.x
# npm (5.6.0 recommanded)
# python2.7

# path variable to the workspace at which Hyperledger will be installed. 
# (not part of the hyperledger documentation, doing this for a betther organization)
echo $(HYPERLEDGER_HOME)
echo "$HOME"
export HYPERLEDGER_HOME="$HOME/hyperledger_ws"

#echo -e "export HYPERLEDGER_HOME=\"\$HOME/hyperledger_ws\"" | tee -a ~/.bashrc
echo "----------------------------------------------" 
# echo "Creating hyperledger workspace..."
# Create a workspace 
# mkdir -p $HYPERLEDGER_HOME
cd $HYPERLEDGER_HOME

echo "HLF home: $HYPERLEDGER_HOME"


# PRE-REQS HYPERLEDGER
echo "----------------------------------------------" 
# Check ubuntu version
echo "Checking ubuntu version..."
# try to source lsb-release, if fails get the distrib version using lsb_release command.
UBUNTU_VERSION=`lsb_release -cs`
echo "distribution is $UBUNTU_VERSION"
echo "distribution is $(lsb_release -cs)"

if [ -z "${UBUNTU_VERSION}" ]; then
    echo "Error: Could not source /etc/lsb-release. Exit";
    exit 1;
fi

echo $UBUNTU_VERSION

# check version is supported
if [ $UBUNTU_VERSION == "xenial" ]; then
    echo "Installing prereqs for Ubuntu ${UBUNTU_VERSION}"
else
    echo "Check Ubuntu version! This install works for xenial";
    exit 1;
fi
echo "----------------------------------------------" 
# Updating package lists
sudo apt-get update
# Curl: Install packages to allow apt to use a repository over HTTPS
sudo apt-get install -y apt-transport-https ca-certificates curl wget gnupg-agent software-properties-common
# ----------------------------------------------
# SCRIPT A PART. (already install during my VM deployment with vagrant)
# Install Docker (and Docker composer)
# ----------------------------------------------
# NOTE: check if I really need compose for multinode deployment.
echo "Install the current stable release of Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
echo "Apply executable permissions to the binary..."
sudo chmod +x /usr/local/bin/docker-compose
echo "----------------------------------------------" 
echo "Installing Golang"
# download the archive
wget  https://dl.google.com/go/go1.12.2.linux-amd64.tar.gz
# extract it into /usr/local, creating a Go tree in /usr/local/go 
sudo tar -C /usr/local -xzf go1.12.2.linux-amd64.tar.gz
rm go1.12.2.linux-amd64.tar.gz

# the location where Go package is installed on your system
export GOROOT="/usr/local/go"
echo -e "export GOROOT=\"/usr/local/go\"" | sudo tee -a /home/ubuntu/.bashrc
# Even though, in Linux, Go’s GOPATH use a default value of $HOME/go, 
# the current Fabric build framework still requires you to set and export that variable, and it must set the GOPATH variable. 
# It must contain only the single directory name for your Go workspace.  (add this to the .bashrc to make it permanent)
export GOPATH="$HYPERLEDGER_HOME/go" 
echo -e "export GOPATH=\"\$HYPERLEDGER_HOME/go\"" | sudo tee -a /home/ubuntu/.bashrc
# extend your command search path to include the Go bin directory
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
echo -e "export PATH=\"\$PATH:\$GOROOT/bin:\$GOPATH/bin\"" | sudo tee -a /home/ubuntu/.bashrc
# this command below just makes to log straight to hyperledger_ws when we log in
cd $HYPERLEDGER_HOME
echo -e "cd $HYPERLEDGER_HOME" | sudo tee -a /home/ubuntu/.bashrc
echo "----------------------------------------------" 
echo "Install Node.js:  requested for developement only..." 
# Versions other than the 8.x series are not supported at this time
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
# installing Node.js will also install NPM, confirm the version of NPM installed:
sudo npm install npm@5.6.0 -g
echo "----------------------------------------------" 
echo "Installing Python"
# The Fabric Node.js SDK requires Python 2.7 in order for npm install operations to complete successfully.
sudo apt-get install -y python

echo "--------------------------------------------------------------------------------------"
echo "Prereqs Done."
echo "Checking results:"
echo "curl version: `curl -V  | grep curl`"
echo "go version: `go version`"
echo "Node.js version: `node --version`"
echo "Python (Node.js requires 2.7): `python --version`"
echo "npm version: `npm --version`"
echo "--------------------------------------------------------------------------------------"
echo "PLEASE LOGOUT and login to take into account the group change: sudo usermod -aG docker"
echo "Check using <docker info> command"
echo "Also check  <docker-compose --version>"
echo "--------------------------------------------------------------------------------------"