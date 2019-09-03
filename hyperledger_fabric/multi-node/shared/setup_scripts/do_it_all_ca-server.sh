#!/bin/bash

./01_start_ca_server.sh

./02_enroll_bootstrap_identity.sh

./03_register_admin.sh client acme-admin pw acme acme
./03_register_admin.sh client budget-admin pw budget budget
./03_register_admin.sh client orderer-admin pw orderer orderer