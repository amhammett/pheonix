#!/bin/bash

HOST=$1
USER=$2
KEY_FILE=$3

shift 3

ansible-playbook configure-apache.yml -i $HOST, \
  --user=$USER --private-key=$KEY_FILE \
  --extra-vars "$@"
