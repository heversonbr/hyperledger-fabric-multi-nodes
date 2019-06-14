#!/bin/bash
set -x
echo "-----------------------------------------------------------------------------------------"
echo "Installing ansible..."

$ sudo apt update
$ sudo apt install software-properties-common
$ sudo apt-add-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible