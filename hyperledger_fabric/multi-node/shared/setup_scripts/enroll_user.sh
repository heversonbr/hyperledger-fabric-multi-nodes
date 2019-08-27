#!/bin/bash

#
# 
# the example below show what we do to enroll a user jdoe
# . ./setclient.sh acme jdoe
# fabric-ca-client enroll -u http://jdoe:pw@192.168.1.10:7054
# ./add-admincerts.sh acme jdoe

ORG_NAME=acme
USER=jdoe
USER_PW=pw
CA_SERVER_HOST=192.168.1.10


. set-ca-client.sh $ORG_NAME $USER

fabric-ca-client enroll -u http://$USER:$USER_PW@$CA_SERVER_HOST:7054

./add-admincerts.sh $ORG_NAME $USER


