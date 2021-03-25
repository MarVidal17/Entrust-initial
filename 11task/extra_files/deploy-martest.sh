#!/bin/bash

# Usage:
# ./kubernetes/deploy-martest.sh

set -e

fatal() {
    printf "\033[0;31m$@\033[0m\n" >&2 && exit 1
}

wait_for_services_ready() {
    kubectl rollout status $1 -n pkihub
}

[[ "$PKIHUB_HOME" == "" ]] && fatal "undefined PKIHUB_HOME environment variable"
[[ "$HELM_RELEASE_NAME_MAR_TEST" == "" ]] && export HELM_RELEASE_NAME_METERING=metering-$CLUSTER_NAME
[[ "$HELM_VALUES_FILE_PATH_MAR_TEST" == "" ]] && export HELM_VALUES_FILE_PATH_METERING=$CONFIG_FOLDER_PATH/pkihub/values-metering.yaml
[[ "$ENABLE_SSL_DB" == "" ]] && export ENABLE_SSL_DB=1
export NAMESPACE=pkihub

mkdir -p $CONFIG_FOLDER_PATH/pkihub

if [[ "$ENABLE_SSL_DB" == "1" ]]; then
  ENABLE_SSL_DB=true
else
  ENABLE_SSL_DB=false
fi

if [[ "$USE_DEBUG_IMAGES" == "1" ]]; then
  DEBUG_TAG=-debug
  allowPrivilegeEscalation=true
  readOnlyRootFilesystem=false
else
  DEBUG_TAG=
  allowPrivilegeEscalation=false
  readOnlyRootFilesystem=true
fi

printf "\033[0;32mDeploying Mar Test Helm Chart into the cluster...\033[0m\n"
cd $PKIHUB_HOME/service
helm install $HELM_RELEASE_NAME_MAR_TEST --values $PKIHUB_HOME/martest/helm/values.yaml \
--namespace $NAMESPACE $PKIHUB_HOME/martest/helm

# Extract the values.yaml file generated from the Helm Chart, and save it in the respective repository
helm get values $HELM_RELEASE_NAME_MAR_TEST \
--namespace pkihub -o yaml > $HELM_VALUES_FILE_PATH_MAR_TEST
