#!/bin/bash

./start_ca_server.sh

./enroll_bootstrap_identity.sh

./register_admin.sh client acme-admin pw acme acme
./register_admin.sh client budget-admin pw budget budget
./register_admin.sh client orderer-admin pw orderer orderer

./enroll_admin.sh acme
./enroll_admin.sh budget
./enroll_admin.sh orderer