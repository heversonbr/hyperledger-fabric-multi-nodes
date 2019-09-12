#!/bin/bash
# based on IBM's bootstrap script

# starting with 1.2.0, multi-arch images are
# release version,  ca version, thirdparty images (couchdb, kafka and zookeeper) version

# source all environment variables
.  /home/ubuntu/hyperledger_ws/install/fabric.env.sh

#export ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')")
ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/amd64/g')")

BINARY_FILE=hyperledger-fabric-${ARCH}-${FABRIC_VERSION}.tar.gz
CA_BINARY_FILE=hyperledger-fabric-ca-${ARCH}-${CA_VERSION}.tar.gz

FABRIC_GIT_REPO=https://github.com/hyperledger/fabric-samples.git

URL_FABRIC="https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric/hyperledger-fabric/${ARCH}-${FABRIC_VERSION}/${BINARY_FILE}"
URL_FABRIC_CA="https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric-ca/hyperledger-fabric-ca/${ARCH}-${CA_VERSION}/${CA_BINARY_FILE}"


echo "----------------------------------------------" 
echo "installing for user: $FABRIC_USER"
echo "fabric_home: $HYPERLEDGER_HOME"
echo $GOROOT
echo $GOPATH
echo $PATH 
echo "----------------------------------------------" 

getSamples() {
    echo "----------------------------------------------------------------------------"
    pwd
    echo "USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME" 
    cd $HYPERLEDGER_HOME
    pwd
    test -f "/bin/bash" && echo "This system has a bash shell"

    # clone (if needed) hyperledger/fabric-samples and checkout corresponding
    # version to the binaries and docker images to be downloaded
    if [ -d $HYPERLEDGER_HOME/fabric-samples ]; then
        # if $HYPERLEDGER_HOME/fabric-samples already exists, go into it and checkout corresponding version
        cd $HYPERLEDGER_HOME/fabric-samples
        echo "===> Checking out v${FABRIC_VERSION} of hyperledger/fabric-samples"
        git checkout v${FABRIC_VERSION}
    else
        echo "===> Cloning hyperledger/fabric-samples repo and checkout v${FABRIC_VERSION}"
        cd $HYPERLEDGER_HOME
        #git clone -b master $FABRIC_GIT_REPO $HYPERLEDGER_HOME/fabric-samples
        if [ $HOME = "/root" ]; then
            echo "igual"
            export HOME="/home/$FABRIC_USER"
            git clone -q -b master $FABRIC_GIT_REPO $HYPERLEDGER_HOME/fabric-samples
            cd  $HYPERLEDGER_HOME/fabric-samples 
            git checkout v${FABRIC_VERSION}
            export HOME="/root"
        else
            echo "different"
            git clone -q -b master $FABRIC_GIT_REPO $HYPERLEDGER_HOME/fabric-samples
            cd  $HYPERLEDGER_HOME/fabric-samples 
            git checkout v${FABRIC_VERSION}
        fi
    fi
    echo "----------------------------------------------------------------------------"
}

getBinaries(){
    #TODO: add a flag to determine when 'ca-fabric client' should be installed (ca-nodes) or not (no-msp nodes) 
    # echo "USER: $USER whoami: `whoami` id -un: `id -un` FABRIC_USER: $FABRIC_USER  HOME: $HOME  LOGNAME: $LOGNAME" 
    echo "----------------------------------------------------------------------------"
    echo "===> Downloading version ${FABRIC_VERSION} platform specific fabric binaries"
    echo "===> Downloading fabric from: " ${URL_FABRIC}

    echo "----------------------------------------------------------------------------"
    curl ${URL_FABRIC} | tar xz || rc1=$?
    echo $rc1
    if [ ! -z "$rc" ]; then
      echo "==> Error: There was an error downloading $BINARY_FILE"
    else
      echo "==> Done"
    fi

    echo "----------------------------------------------------------------------------"
    echo "===> Downloading version ${CA_VERSION} platform specific fabric-ca-client binary"
    echo "===> Downloading fabric-ca from: " ${URL_FABRIC_CA}

    curl ${URL_FABRIC_CA} | tar xz || rc1=$?
    echo $rc1
    if [ ! -z "$rc" ]; then
      echo "==> Error: There was an error downloading $CA_BINARY_FILE"
    else
      echo "==> Done"
    fi
}


getAllImages() {
    which docker >& /dev/null
    if [ "$?" == 1 ]; then
        echo "==> Docker not installed! "
        exit 1;
    fi
    # pulls docker images from fabric and chaincode repositories
    for IMAGES in peer orderer ccenv tools baseos nodeenv javaenv; do
        echo "==> FABRIC IMAGE: $IMAGES"
        docker pull hyperledger/fabric-$IMAGES:$FABRIC_VERSION
        docker tag hyperledger/fabric-$IMAGES:$FABRIC_VERSION hyperledger/fabric-$IMAGES
    done
    for IMAGES in couchdb kafka zookeeper; do
        echo "==> THIRDPARTY DOCKER IMAGE: $IMAGES"
        docker pull hyperledger/fabric-$IMAGES:$THIRDPARTY_IMAGE_VERSION
        docker tag hyperledger/fabric-$IMAGES:$THIRDPARTY_IMAGE_VERSION hyperledger/fabric-$IMAGES
    done
    echo "==> FABRIC CA (server and client) IMAGE"
    docker pull hyperledger/fabric-ca:$CA_VERSION
    docker tag hyperledger/fabric-ca:$CA_VERSION hyperledger/fabric-ca
    echo "===> List hyperledger docker images"
	  docker images | grep hyperledger*
}


cd $HYPERLEDGER_HOME
echo "----------------------------------------------" 
echo "bootstrap : Installing Hyperledger Fabric binaries"
getBinaries
echo "----------------------------------------------" 
echo "bootstrap : Installing Hyperledger Fabric docker images"
#getAllImages
#echo "----------------------------------------------" 
echo "bootstrap : Installing hyperledger/fabric-samples repo"
getSamples
echo "----------------------------------------------" 