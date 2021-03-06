#!/bin/bash

if [ $# -eq 0  ]; then
	echo "Usage: configure-tas4k8s.sh {domain} {vendor_dir}"
	echo "  Note: {vendor_dir} is an optional parameter and if not specified defaults to [ vendor ] relative to the scipt execution path"
	exit 1
fi

DOMAIN="$1"

if [ -z "$2" ]; then
  	VENDOR_DIR="vendor"
else
	VENDOR_DIR="$2"
fi

TMP_DIR=/tmp/tanzu-application-service
VENDIR_DIR=${TMP_DIR}/config/_ytt_lib/github.com/cloudfoundry/cf-for-k8s

# PATCH #1
# Overwrite the embedded cf-for-k8s/hack/generate-values.sh script so that Terraform variables
# drive certain configuration property values like cf_admin_password and nested configuration property values underneath app_registry
mv ${VENDIR_DIR}/hack/generate-values.sh ${VENDIR_DIR}/hack/generate-values.sh.original
cp -f scripts/generate-values.sh ${VENDIR_DIR}/hack/generate-values.sh

# Generate initial configuration values
mkdir -p /tmp/tanzu-application-service/configuration-values
YTT_LIB_DIR="${PWD}"
cd /tmp/tanzu-application-service || exit
./bin/generate-values.sh -d "${DOMAIN}" > /tmp/tanzu-application-service/configuration-values/deployment-values.yml
cd "${YTT_LIB_DIR}" || exit

# Copy config into place
mkdir -p $VENDOR_DIR
cp -Rf /tmp/tanzu-application-service/config $VENDOR_DIR
cp -Rf /tmp/tanzu-application-service/config-optional $VENDOR_DIR
cp -Rf /tmp/tanzu-application-service/configuration-values $VENDOR_DIR
