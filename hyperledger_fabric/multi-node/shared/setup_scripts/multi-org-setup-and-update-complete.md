## terminal caserver-admin
cd ~/ca/multi-org-ca
./clean.sh all
./run-all.sh
##Server Started ... Logs available at /home/vagrant/ca/multi-org-ca/server/server.log
. setclient.sh caserver admin
fabric-ca-client enroll -u http://admin:pw@localhost:7054
fabric-ca-client identity list

## nouveau terminal `~/ca/multi-org-ca` acme-admin
. setclient.sh acme acme-admin   (.setclient.sh acme admin ???)
fabric-ca-client enroll -u http://acme-admin:pw@192.168.1.10:7054
fabric-ca-client register --id.type user --id.name jdoe --id.secret pw --id.affiliation acme.logistics
fabric-ca-client identity list
## nouveau terminal `~/ca/multi-org-ca` jdoe
. ./setclient.sh acme jdoe
fabric-ca-client enroll -u http://jdoe:pw@192.168.1.10:7054
./add-admincerts.sh acme jdoe
## nouveau terminal `~/orderer/multi-org-ca/` orderer
cd ../../orderer/multi-org-ca/
./clean.sh
cp ../../setup/config/multi-org-ca/yaml.0/configtx.yaml ./
cp ../../setup/config/multi-org-ca/yaml.0/orderer.yaml ./
./generate-genesis.sh
./register-enroll-orderer.sh
./generate-channel-tx.sh
cd ../../peer/multi-org-ca/
./sign-channel-tx.sh acme
sudo mkdir /var/ledgers						## Etudier alternative launch.sh
sudo chown vagrant:vagrant /var/ledgers/	## du orderer
cd ../../orderer/multi-org-ca/				##
orderer 		
							## ./launch.sh
## nouveau terminal `~/peer/multi-org-ca` peer1
cd ../../peer/multi-org-ca/
./clean.sh
./submit-create-channel.sh acme admin
### dans logs orderer : newChain -> INFO 019 Created and starting new chain airlinechannel
cp ../../setup/config/multi-org-ca/yaml.0/core.yaml acme/
./register-enroll-peer.sh acme peer1
./launch-peer.sh acme peer1 				## logs dans /home/vagrant/peer/multi-org-ca/acme/peer1/peer.log
cat acme/peer1/peer.log
. ./set-env.sh acme admin
env|grep CORE
CORE_PEER_CHAINCODELISTENADDRESS=localhost:7052
CORE_PEER_LOCALMSPID=AcmeMSP
CORE_PEER_LISTENADDRESS=localhost:7051
CORE_PEER_MSPCONFIGPATH=/home/vagrant/peer/multi-org-ca/../../ca/multi-org-ca/client/acme/admin/msp
CORE_PEER_ID=admin
CORE_PEER_EVENTS_ADDRESS=localhost:7053
CORE_PEER_FILESYSTEM_PATH=/var/ledgers/multi-org-ca/acme/admin/ledger
CORE_PEER_ADDRESS=localhost:7051
CORE_PEER_GOSSIP_BOOTSTRAP=localhost:7051
export FABRIC_LOGGING_SPEC=warning
./join-airline-channel.sh acme peer1 ## only admin is allowed to play join command
cat acme/peer1/peer.log

## nouveau terminal peer2
./register-enroll-peer.sh acme peer2
./launch-peer.sh acme peer2 8050
cat acme/peer2/peer.log
. ./set-env.sh acme peer2 8050 admin
peer channel fetch 0 -c airlinechannel -o localhost:7050
peer channel join -o localhost:7050 -b airlinechannel_0.block
peer channel list
cat acme/peer2/peer.log


. ./set-env.sh acme peer2 8050 admin
./validate-with-chaincode-2.sh ## il faut que go soit bien implémenté
								## et d'autres problèmes...
### voir fichier validate-with-chaincode-2.log dans ~/peer/multi-org-ca (snapshot redonecompleted)

## Nouveau terminal config-update
. ./set-env.sh acme peer1 7050 admin
./fetch-config-json.sh ordererchannel
emacs config/cfg_block_no_envelope_mod.json ## modifier la ligne max_message_count (de 10 à 5)
./generate-config-update.sh ordererchannel
./sign-config-update.sh acme
./sign-config-update.sh orderer
./submit-config-update-tx.sh acme admin ordererchannel
## validation:
./fetch-config-json.sh ordererchannel
less ./config/cfg_block_no_envelope_mod.json ## must have changed ; also INFO 002 Received block: 2 <== must have changed
## Nouveau terminal addOrg
cp ../../setup/config/multi-org-ca/yaml.1/configtx.yaml config/ ## attention au chemin relatif du MSPDir : il faut rajouter un "../"
. set-identity.sh acme admin
./fetch-config-json.sh airlinechannel
./add-member-org.sh
./generate-config-update.sh airlinechannel
./sign-config-update.sh acme admin
./submit-config-update-tx.sh acme admin airlinechannel
## Nouveau terminal budget-peer1:
. set-identity.sh acme admin
./fetch-config-json.sh airlinechannel ## attebtuib ay Received block
./register-enroll-peer.sh budget budget-peer1
./launch-peer.sh budget budget-peer1 9050 ## pourquoi le WARN 024 Could not connect to Endpoint: ?
										  ## ça c'est franchement zarb !
./join-regular-peer-to-airlinechannel.sh budget budget-peer1 9050 ## est en relation avec acme peer1 mais pas acme peer2
cat /home/vagrant/peer/multi-org-ca/budget/budget-peer1/peer.log
## Nouveau terminal validation-3:
./validate-with-chaincode-3.sh