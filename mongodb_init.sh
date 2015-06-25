#!/bin/bash
#
# Admin config script for the PDC's HubDB (MongoDB) service


# Halt on errors or unset variables
#
set -e -o nounset


# Run after initial boot, wait 10 seconds for mongo to start
#
sleep 5


# Set db keys to prevent duplicates
#
mongo query_composer_development --eval \
  'printjson( db.users.ensureIndex({ username : 1 }, { unique : true }))'
mongo query_composer_development --eval \
  'printjson( db.endpoints.ensureIndex({ base_url : 1 }, { unique : true }))'


# Import admin and user accounts
#
mongo query_composer_development --eval \
  'db.users.insert({ "first_name" : "PDC", "last_name" : "Admin", "username" : "admin", "email" : "admin@pdc.io", "encrypted_password" : "\$2a\$10\$ZSuPxdODbumiMGOxtVSpRu0Rd0fQ2HhC7tMu2IobKTaAsPMmFlBD.", "agree_license" : true, "approved" : true, "admin" : true })'
mongo query_composer_development --eval \
  'db.users.insert({ "first_name" : "PDC", "last_name" : "User", "username" : "user", "email" : "user@pdc.io", "encrypted_password" : "\$2a\$10\$ZSuPxdODbumiMGOxtVSpRu0Rd0fQ2HhC7tMu2IobKTaAsPMmFlBD.", "agree_license" : true, "approved" : true, "admin" : true })'
