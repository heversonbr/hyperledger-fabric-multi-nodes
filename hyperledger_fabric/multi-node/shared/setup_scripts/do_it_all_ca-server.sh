#!/bin/bash

./01_start_ca_server.sh

./02_enroll_bootstrap_identity.sh

./03_register_admin.sh client org1-admin    pw org1    org1
./03_register_admin.sh client org2-admin    pw org2    org2
./03_register_admin.sh client orderer-admin pw orderer orderer