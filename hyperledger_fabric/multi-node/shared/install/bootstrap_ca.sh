#!/bin/bash
# based on IBM's bootstrap script

# starting with 1.2.0, multi-arch images are
# release version,  ca version, thirdparty images (couchdb, kafka and zookeeper) version
FABRIC_VERSION=1.4.1              
CA_VERSION=1.4.1                 
THIRDPARTY_IMAGE_VERSION=0.4.15   

#export ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')")
ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/amd64/g')")

BINARY_FILE=hyperledger-fabric-${ARCH}-${FABRIC_VERSION}.tar.gz
CA_BINARY_FILE=hyperledger-fabric-ca-${ARCH}-${CA_VERSION}.tar.gz


getSamples() {

  cd $HYPERLEDGER_HOME
  echo "HLF home: $HYPERLEDGER_HOME"

  # clone (if needed) hyperledger/fabric-samples and checkout corresponding
  # version to the binaries and docker images to be downloaded
  if [ -d first-network ]; then
    # if we are in the fabric-samples repo, checkout corresponding version
    echo "===> Checking out v${FABRIC_VERSION} of hyperledger/fabric-samples"
    git checkout v${FABRIC_VERSION}
  elif [ -d fabric-samples ]; then
    # if fabric-samples repo already cloned and in current directory,
    # cd fabric-samples and checkout corresponding version
    echo "===> Checking out v${FABRIC_VERSION} of hyperledger/fabric-samples"
    cd fabric-samples
    git checkout v${FABRIC_VERSION}
  else
    echo "===> Cloning hyperledger/fabric-samples repo and checkout v${FABRIC_VERSION}"
    git clone -b master https://github.com/hyperledger/fabric-samples.git
    cd fabric-samples 
    git checkout v${FABRIC_VERSION}
  fi
}

getBinaries(){

    cd $HYPERLEDGER_HOME
    echo "HLF home: $HYPERLEDGER_HOME"

    echo "===> Downloading version ${FABRIC_VERSION} platform specific fabric binaries"
    URL="https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric/hyperledger-fabric/${ARCH}-${FABRIC_VERSION}/${BINARY_FILE}"
    echo "===> Downloading fabric from: " ${URL}
    curl ${URL} | tar xz || rc=$?
    if [ ! -z "$rc" ]; then
        echo "==> Error: There was an error downloading $BINARY_FILE"
	else
	    echo "==> Done"
    fi

    echo "===> Downloading version ${CA_VERSION} platform specific fabric-ca-client binary"
    URL="https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric-ca/hyperledger-fabric-ca/${ARCH}-${CA_VERSION}/${CA_BINARY_FILE}"
    echo "===> Downloading fabric-ca from: " ${URL}
    curl ${URL} | tar xz || rc=$?
    if [ ! -z "$rc" ]; then
        echo "==> Error: There was an error downloading $CA_BINARY_FILE"
	else
	    echo "==> Done"
    fi

}

getAllImages() {

    cd $HYPERLEDGER_HOME
    echo "HLF home: $HYPERLEDGER_HOME"

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

    echo "==> FABRIC CA IMAGE"
    docker pull hyperledger/fabric-ca:$CA_VERSION
    docker tag hyperledger/fabric-ca:$CA_VERSION hyperledger/fabric-ca

    echo "===> List hyperledger docker images"
	docker images | grep hyperledger*

}

echo "----------------------------------------------" 
echo "Installing Hyperledger Fabric binaries"
getBinaries
echo "----------------------------------------------" 
echo "Installing Hyperledger Fabric docker images"
getAllImages
echo "----------------------------------------------" 
echo "Installing hyperledger/fabric-samples repo"
getSamples
echo "----------------------------------------------" 