# Dockerfile for the PDC's HubDB service
#
#
# HubDB for PDC-collected aggregate data.  Based on Mongo official 3.0.
#
# Example:
# sudo docker pull pdcbc/hubdb
# sudo docker run -d --name hubdb -h hubdb --restart=always \
#   -v /pdc/data/private/mongo_live/:/data/db/:rw \
#   -v /pdc/data/private/mongo_dump/:/data/dump/:rw \
#   pdcbc/hubdb:latest
#
# Folder paths
# - Mongo live db: -v </path/>:/data/db/:rw
# - Mongo dumps:   -v </path/>:/data/dump/:rw
#
#
FROM phusion/baseimage
MAINTAINER derek.roberts@gmail.com


################################################################################
# Start - modified from https://hub.docker.com/_/mongo/
################################################################################


# Create users and groups
#
RUN groupadd -r mongodb; \
		useradd -r -g mongodb mongodb


# Packages
#
RUN apt-get update; \
		apt-get install -y --no-install-recommends \
			ca-certificates; \
		rm -rf /var/lib/apt/lists/*


# MongoDB
#
ENV MONGO_MAJOR 3.2
ENV MONGO_VERSION 3.2.0
#
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys DFFA3DCF326E302C4787673A01C4E7FAAAB2461C; \
		apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 42F3E95A2C4F08279C4960ADD68FA50FEA312927; \
		echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/$MONGO_MAJOR multiverse" > /etc/apt/sources.list.d/mongodb-org.list
RUN apt-get update; \
		apt-get install -y \
			mongodb-org=$MONGO_VERSION \
			mongodb-org-server=$MONGO_VERSION \
			mongodb-org-shell=$MONGO_VERSION \
			mongodb-org-mongos=$MONGO_VERSION \
			mongodb-org-tools=$MONGO_VERSION; \
		rm -rf /var/lib/apt/lists/* \
			/var/lib/mongodb \
			/etc/mongod.conf
RUN mkdir -p /data/db; \
		chown -R mongodb:mongodb /data/db


################################################################################
# End - modified from https://hub.docker.com/_/mongo/
################################################################################


# Prepare /app/ folder
#
WORKDIR /app/
COPY . .


# Mongo startup
#
RUN mkdir -p /etc/service/mongod/; \
		SCRIPT=/etc/service/mongod/run; \
	  ( \
	    echo "#!/bin/bash"; \
	    echo ""; \
	    echo "set -e -o nounset"; \
			echo ""; \
			echo ""; \
			echo "# Start mongod"; \
			echo "#"; \
			echo "chown -R mongodb:mongodb /data/db"; \
			echo "exec /sbin/setuser mongodb mongod --storageEngine wiredTiger"; \
	  )  \
	    >> ${SCRIPT}; \
		chmod +x ${SCRIPT}


# Maintenance script and cron job
#
RUN SCRIPT=/app/mongo_maint.sh; \
	  ( \
	    echo "# Run database dump/maintenance script (boot, daily 1:15 AM)"; \
			echo "@reboot ${SCRIPT}"; \
	    echo "15 1 * * * ${SCRIPT}"; \
	  ) \
	    | crontab -


# Ports and volumes
#
EXPOSE 27017
#
VOLUME /data/db/
