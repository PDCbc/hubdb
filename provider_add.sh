#!/bin/bash
#
# Halt on errors or uninitialized variables
#
set -e -o nounset


# Expected input
#
# $0 this script
# $1 Doctor (clinician) ID


# Check parameters
#
if([ $# -lt 1 ]||[ $# -gt 1 ])
then
        echo
        echo "Unexpected number of parameters."
        echo
        echo "Usage: providers_add.sh [doctorID]"
        echo
        exit
fi


# Set variables from parameters
#
DOCTOR=${1}


# Get script directory and target file
#
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
TARGET=${DIR}/providers.txt


# Add provider
#
if(! grep --quiet ${DOCTOR} ${TARGET} )
then
        echo ${DOCTOR} | sudo tee -a ${TARGET}
fi
