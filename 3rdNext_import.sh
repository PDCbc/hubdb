#!/bin/bash
#
# Import 3rd Next
#
#
# Exit on errors or uninitialized variables
set -e -o nounset


# Start in data folder
#
cd /data/3rdNext


# Create a list of text files
#
FILES=$(find . -maxdepth 1 -type f -name "*.txt")


# Import each text file and move it to archived
#
for f in ${FILES}
do
  mongoimport --db query_composer_development --collection thirdnexts --type json --file ${f}
done
