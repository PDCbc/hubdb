#!/bin/bash
#
# Append Endpoint to the Hub's public (authorized) key list


# Halt on errors or unset variables
#
set -e -o nounset


# Add Endpoint pdc-#### and its expected address
#
mongo query_composer_development --eval \
  'db.endpoints.insert({ "name" : "'pdc-${1}'", "base_url" : "http://localhost:'`expr 40000 + ${1}`'" })'


# Append Endpoint public key to authorized_keys
#
export PUB_KEY=${2}
(
  echo ${PUB_KEY} | sudo tee -a ${PATH_KEYS_HUB_AUTH}/authorized_keys
  sudo chown vagrant:vagrant ${PATH_KEYS_HUB_AUTH}/authorized_keys
  echo "SSH public key recorded"
) || echo "ERROR: SSH public key not recorded"
