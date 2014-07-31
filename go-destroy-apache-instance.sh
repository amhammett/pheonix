#!/bin/bash

if [[ "$#" -lt 3 ]] ; then
  echo "usage: $0 <host> <user> <ssh-key>"
  exit 1
fi

HOST=$1
USER=$2
KEY_FILE=$3

shift 3

ansible-playbook destroy-apache-instance.yml -i $HOST, \
  --user=$USER --private-key=$KEY_FILE \
  --extra-vars "$@"
