#!/bin/bash
#
# Create dump of MongoDB


# Dump MongoDB, report failure if unsuccessful
#
mkdir -p /data/dump/
(
  mongodump --out /data/dump/
) || \
(
  TIMESTAMP=`date +"%Y%m%d%H%M%S"`
  FILE=/data/dump/mongodump_message-$TIMESTAMP.txt
  df > $FILE
  mailx -s"MongoDB dump failed on hub.pdc.io" errors@pdc.io < $FILE
  rm $FILE
)
