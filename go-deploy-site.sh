#!/bin/bash

host=$1
user=$2

ansible-playbook deploy-site.yml -i $1, \
  --extra-vars "user=$2" 