#!/bin/bash
#
# Append Endpoint to the Hub's public (authorized) key list


# Halt on errors or unset variables
#
set -e -o nounset -x


# Remove entry for an endpoint
#
mongo query_composer_development --eval \
  'db.endpoints.remove({ "base_url" : "http://localhost:'`expr 40000 + ${1}`'" })'
