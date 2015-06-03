#!/bin/bash
#
# Append Endpoint to the HubDB


# Halt on errors or unset variables
#
set -e -o nounset -x


# Add JSON for Endpoint and URL
#
mongo query_composer_development --eval \
  'db.endpoints.insert({ "name" : "'ep${1}'", "base_url" : "http://localhost:'`expr 40000 + ${1}`'" })'
