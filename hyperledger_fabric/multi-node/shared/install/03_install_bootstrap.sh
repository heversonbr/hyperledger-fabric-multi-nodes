#!/bin/bash
#######################################################################################
# based on IBM's bootstrap script
# starting with 1.2.0, multi-arch images are
# release version,  ca version, thirdparty images (couchdb, kafka and zookeeper) version
########################################################################################
# source all environment variables
.  /home/ubuntu/hyperledger_ws/install/fabric.env.sh

#export ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')")
ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/amd64/g')")

BINARY_FILE=hyperledger-fabric-${ARCH}-${FABRIC_VERSION}.tar.gz
CA_BINARY_FILE=hyperledger-fabric-ca-${ARCH}-${CA_VERSION}.tar.gz

FABRIC_GIT_REPO=https://github.com/hyperledger/fabric-samples.git

URL_FABRIC="https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric/hyperledger-fabric/${ARCH}-${FABRIC_VERSION}/${BINARY_FILE}"
URL_FABRIC_CA="https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric-ca/hyperledger-fabric-ca/${ARCH}-${CA_VERSION}/${CA_BINARY_FILE}"
echo "-----------------------------------------------------------------------------------------"
echo "Bootstraping Fabric components..."
echo "-----------------------------------------------------------------------------------------"
echo "installing for user: $FABRIC_USER"
echo "fabric_home: $HYPERLEDGER_HOME"
echo $GOROOT
echo $GOPATH
echo $PATH
echo "-----------------------------------------------------------------------------------------"

getSamples() {
    echo "-----------------------------------------------------------------------------------------"
    echo "--------------------------------- DEBUG: getSamples--------------------------------------"
    pwd
    echo "USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME"
    cd $HYPERLEDGER_HOME
    pwd
    test -f "/bin/bash" && echo "This system has a bash shell"
    echo "-----------------------------------------------------------------------------------------"

    # clone (if needed) hyperledger/fabric-samples and checkout corresponding
    # version to the binaries and docker images to be downloaded
    if [ -d $HYPERLEDGER_HOME/fabric-samples ]; then
        # if $HYPERLEDGER_HOME/fabric-samples already exists, go into it and checkout corresponding version
        cd $HYPERLEDGER_HOME/fabric-samples
        echo "===> [install_03_bootstrap.sh (getSamples)] : Checking out v${FABRIC_VERSION} of hyperledger/fabric-samples"
        git checkout v${FABRIC_VERSION}
    else
        echo "===> [install_03_bootstrap.sh (getSamples)] : Cloning hyperledger/fabric-samples repo and checkout v${FABRIC_VERSION}"
        cd $HYPERLEDGER_HOME
        #git clone -b master $FABRIC_GIT_REPO $HYPERLEDGER_HOME/fabric-samples
        if [ $HOME = "/root" ]; then
            echo "running from /root"
            export HOME="/home/$FABRIC_USER"
            git clone -q -b master $FABRIC_GIT_REPO $HYPERLEDGER_HOME/fabric-samples
            cd  $HYPERLEDGER_HOME/fabric-samples
            git checkout v${FABRIC_VERSION}
            export HOME="/root"
        else
            echo "running from $HOME"
            git clone -q -b master $FABRIC_GIT_REPO $HYPERLEDGER_HOME/fabric-samples
            cd  $HYPERLEDGER_HOME/fabric-samples
            git checkout v${FABRIC_VERSION}
        fi
    fi
    sudo chown -R ubuntu:ubuntu $HYPERLEDGER_HOME/fabric-samples
    echo "-----------------------------------------------------------------------------------------"
}

getBinaries(){
    #TODO: add a flag to determine when 'ca-fabric client' should be installed (ca-nodes) or not (no-msp nodes)
    echo "--------------------------------- DEBUG: getBinaries-------------------------------------"

    pwd
    echo "USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME"
    cd $HYPERLEDGER_HOME
    pwd
    test -f "/bin/bash" && echo "This system has a bash shell"
    echo "-----------------------------------------------------------------------------------------"
    echo "===> [install_03_bootstrap.sh (getBinaries)] : Downloading version ${FABRIC_VERSION} platform specific fabric binaries"
    echo "===> [install_03_bootstrap.sh (getBinaries)] : Downloading fabric from: " ${URL_FABRIC}
    echo "-----------------------------------------------------------------------------------------"
    curl ${URL_FABRIC} | tar xz || rc1=$?
    echo $rc1
    if [ ! -z "$rc" ]; then
      echo "==> Error: There was an error downloading $BINARY_FILE"
    else
      echo "==> Done"
    fi
    echo "moving config directory created by getBinaries to config_files only for backup "
    sudo mkdir -p config_files/fabric-config/
    sudo chown -R ubuntu:ubuntu  $HYPERLEDGER_HOME/config_files/fabric-config
    cp $HYPERLEDGER_HOME/config/* $HYPERLEDGER_HOME/config_files/fabric-config/

    sudo rm -Rf $HYPERLEDGER_HOME/config/

    #TODO: maybe remove this later. maybe we dont need it as all config files are treated at config.

    echo "-----------------------------------------------------------------------------------------"
    echo "===> [install_03_bootstrap.sh (getBinaries)] : Downloading version ${CA_VERSION} platform specific fabric-ca-client binary"
    echo "===> [install_03_bootstrap.sh (getBinaries)] : Downloading fabric-ca from: " ${URL_FABRIC_CA}

    curl ${URL_FABRIC_CA} | tar xz || rc1=$?
    echo $rc1
    if [ ! -z "$rc" ]; then
      echo "==> Error: There was an error downloading $CA_BINARY_FILE"
    else
      echo "==> Done"
    fi

    sudo chown -R ubuntu:ubuntu  $HYPERLEDGER_HOME/bin


}


getAllImages() {
    echo "--------------------------------- DEBUG: getAllImages------------------------------------"
    pwd
    echo "USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME"
    cd $HYPERLEDGER_HOME
    pwd
    test -f "/bin/bash" && echo "bash ok! "
    echo "-----------------------------------------------------------------------------------------"
    which docker >& /dev/null
    if [ "$?" == 1 ]; then
        echo "==> Docker not installed! "
        exit 1;
    fi
    # pulls docker images from fabric and chaincode repositories
    # according to  (https://jira.hyperledger.org/browse/FAB-16812)  nodeenv is not used in 1.4 as well as baseos.
    # for IMAGES in peer orderer ccenv tools baseos nodeenv javaenv; do
    for IMAGES in peer orderer ccenv tools javaenv; do
        echo "-----------------------------------------------------------------------------------------"
        echo "==> FABRIC IMAGE: $IMAGES"
        echo "PULLING: docker pull hyperledger/fabric-$IMAGES:$FABRIC_VERSION"
        docker pull "hyperledger/fabric-$IMAGES:$FABRIC_VERSION"
        echo "TAGGING: docker tag hyperledger/fabric-$IMAGES:$FABRIC_VERSION hyperledger/fabric-$IMAGES"
        docker tag "hyperledger/fabric-$IMAGES:$FABRIC_VERSION" "hyperledger/fabric-$IMAGES"

    done
    ## there is a problem with the baseos image pulling. im doing manually and temporarily here: to be sure that is coming.
    #docker pull hyperledger/fabric-baseos:0.4.15
    #for IMAGES in couchdb kafka zookeeper; do
    for IMAGES in couchdb baseos; do
        echo "-----------------------------------------------------------------------------------------"
        echo "==> THIRDPARTY DOCKER IMAGE: $IMAGES"
        echo "PULLING: docker pull hyperledger/fabric-$IMAGES:$THIRDPARTY_IMAGE_VERSION"
        docker pull "hyperledger/fabric-$IMAGES:$THIRDPARTY_IMAGE_VERSION"
        echo "TAGGING: docker tag hyperledger/fabric-$IMAGES:$THIRDPARTY_IMAGE_VERSION hyperledger/fabric-$IMAGES"
        docker tag "hyperledger/fabric-$IMAGES:$THIRDPARTY_IMAGE_VERSION" "hyperledger/fabric-$IMAGES"
    done

    echo "==> FABRIC CA (server and client) IMAGE: NOT PULLING CA-IMAGES: check bootstrap (line 132) if needed! "
    #docker "pull hyperledger/fabric-ca:$CA_VERSION"
    #docker "tag hyperledger/fabric-ca:$CA_VERSION" "hyperledger/fabric-ca"
    echo "-----------------------------------------------------------------------------------------"
    echo "===> IMPORTANT: Listing hyperledger docker images"
    docker images
    docker ps -a
    echo "-----------------------------------------------------------------------------------------"
}


cd $HYPERLEDGER_HOME
echo "-----------------------------------------------------------------------------------------"
echo "bootstrap : Installing Hyperledger Fabric binaries"
getBinaries
echo "-----------------------------------------------------------------------------------------"
echo "bootstrap : Installing Hyperledger Fabric docker images"
getAllImages
echo "-----------------------------------------------------------------------------------------"
echo "bootstrap : Installing hyperledger/fabric-samples repo"
getSamples
echo "-----------------------------------------------------------------------------------------"
