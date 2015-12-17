# Dockerfile for the PDC's HubDB service
#
#
# HubDB for PDC-collected aggregate data.  Based on Mongo official 3.0.
#
# Example:
# sudo docker pull pdcbc/hubdb
# sudo docker run -d --name hubdb -h hubdb --restart=always \
#   -v ${PATH_MONGO_LIVE}:/data/db/:rw \
#   -v ${PATH_MONGO_DUMP}:/data/dump/:rw \
#   pdcbc/hubdb:latest
#
# Folder paths
# - Mongo live db: -v </path/>:/data/db/:rw
# - Mongo dumps:   -v </path/>:/data/dump/:rw
#
# Releases
# - https://github.com/PDCbc/gateway/releases
#
#
FROM phusion/baseimage
MAINTAINER derek.roberts@gmail.com
ENV RELEASE 0.1.6


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
ENV MONGO_MAJOR 3.0
ENV MONGO_VERSION 3.0.7
#
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10; \
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


# Volume
#
RUN mkdir -p /data/db; \
		chown -R mongodb:mongodb /data/db
VOLUME /data/db


# Port
#
EXPOSE 27017


################################################################################
# End - modified from https://hub.docker.com/_/mongo/
################################################################################


# Packages
#
RUN apt-get update; \
    apt-get install -y \
      git; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Prepare /app/ folder
#
WORKDIR /app/
RUN git clone https://github.com/pdcbc/hubdb.git . -b ${RELEASE}


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
		echo "#exec mongod --storageEngine wiredTiger"; \
		echo "exec mongod"; \
  )  \
    >> ${SCRIPT}; \
	chmod +x ${SCRIPT}


# Maintenance script and cron job
#
RUN SCRIPT=/app/mongo_maint.sh; \
  ( \
    echo "# Run database dump/maintenance script (boot, daily 1:15 AM)"; \
		echo "@reboot "${SCRIPT}; \
    echo "15 1 * * * "${SCRIPT}; \
  ) \
    | crontab -
