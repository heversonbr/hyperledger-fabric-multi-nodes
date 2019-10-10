#!/bin/bash

echo "-----------------------------------------------------------------------------------------"
echo "Installing docker..."

# source all environment variables
.  /home/ubuntu/hyperledger_ws/install/fabric.env.sh

echo "installing with user: $USER"
echo "installing with user: $FABRIC_USER"

# check if environment variables were added into .bashrc , update .bashrc if not! \
grep "source $HYPERLEDGER_HOME/install/fabric.env.sh" /home/$FABRIC_USER/.bashrc

status=$?
if [ $status -eq 0 ]; then 
    echo "found"
    echo "source $HYPERLEDGER_HOME/install/fabric.env.sh already in /home/$FABRIC_USER/.bashrc. Doing nothing!" 
else 
    echo "not found"
    echo "source $HYPERLEDGER_HOME/install/fabric.env.sh" | sudo tee -a /home/$FABRIC_USER/.bashrc
fi


# install the latest version

# Update the apt package index
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS:
sudo apt-get install -y  apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# set up the stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"

# Update the apt package index
sudo apt-get update  

echo "-----------------------------------------------------------------------------------------"
# to install latest:
# sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# or to install specific version: 
# original from docker web-site (it does not work for specific version of docker-cli) 
# DOCKER_VERSION_STRING=`apt-cache madison docker-ce | grep $DOCKER_VERSION | head -1 | awk '{print $3}'`
# sudo apt-get install docker-ce=<$DOCKER_VERSION_STRING> docker-ce-cli=<$DOCKER_VERSION_STRING> containerd.io
# sudo apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 18.06 | head -1 | awk '{print $3}')


echo "installing latest version of Docker"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "-----------------------------------------------------------------------------------------"
echo "setting docker to run as non-root"
# sudo groupadd docker
sudo gpasswd -a $FABRIC_USER docker
# newgrp docker
sudo usermod -aG docker $FABRIC_USER

echo "END of Docker installation ---------------------------------------------------------------"
