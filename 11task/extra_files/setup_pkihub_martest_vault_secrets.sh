#!/bin/bash

set -e

fatal() {
    printf "\033[0;31m$@\033[0m\n" >&2 && exit 1
}

[[ "$SECRET_FOLDER_PATH" == "" ]] && fatal "SECRET_FOLDER_PATH env var is not set"

# Store the DB Password to each service that needs to access it
vault kv put secret/pkihub/martest/somepassword secretname='somepassword' secretvalue='mypassword'

for dir in $SECRET_FOLDER_PATH/pkihub/*
do
  serviceName=${dir##*/}
  for file in $dir/*; do
    filename=${file##*/}
    vault kv put secret/pkihub/$serviceName/${filename//.} secretname=${filename//.} secretvalue=@$file
  done
done

echo -e "Success! All PKIHub MarTest secrets written in Vault"
