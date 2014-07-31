#!/bin/bash

if [[ "$#" -lt 4 ]] ; then
  echo "usage: $0 <host> <user> <ssh-key> <site>"
  exit 1
fi

HOST=$1
USER=$2
KEY_FILE=$3
SITE=$4

shift 4

ansible-playbook deploy-site.yml -i $HOST, \
  --user=$USER --private-key=$KEY_FILE \
  --extra-vars "site=$SITE $@"
