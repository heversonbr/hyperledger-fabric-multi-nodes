#!/bin/bash

./01_start_ca_server.sh

./02_enroll_bootstrap_identity.sh

./03_register_admin.sh client bcom-admin pw bcom acme
./03_register_admin.sh client orange-admin pw orange budget
./03_register_admin.sh client orderer-admin pw orderer orderer