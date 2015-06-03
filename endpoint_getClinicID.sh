#!/bin/bash
#
# Append Endpoint to the Hub's public (authorized) key list


# Halt on errors or unset variables
#
set -e -o nounset -x


# Obtain clinic number
#
mongo query_composer_development --eval \
  '{ "base_url" : "http://localhost:`expr 40000 + ${1}`" }, { "_id": 1 }' \
  | grep -o "(.*)" | grep -io "\w\+"
