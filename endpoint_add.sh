#!/bin/bash
#
# Append Endpoint to the HubDB


# Halt on errors or unset variables
#
set -e -o nounset


# Expected input
#
# $0 this script
# $1 Gateway ID number
# $2 Endpoint name


# Check parameters
#
if [ $# - 2 ]
then
	echo ""
	echo "Unexpected number of parameters."
	echo ""
	echo "Usage: endpoint_add.sh [gatewayID] [optional:endpointName]"
	echo ""
	exit
fi


# Assign Endpoint Name if not specified
#
EPNAME=${2:-ep$1}


# If record already exists, then remove it
#
mongo query_composer_development --eval \
  'db.endpoints.remove({ "base_url" : "http://localhost:'`expr 40000 + ${1}`'" })'


# Add JSON for Endpoint and URL
#
mongo query_composer_development --eval \
  'db.endpoints.insert({ "name" : "'${EPNAME}'", "base_url" : "http://localhost:'`expr 40000 + ${1}`'" })'
