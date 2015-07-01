# Dockerfile for the PDC's HubDB service
#
# Base image
#
FROM mongo


# Update system, install Lynx
#
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'Dpkg::Options{ "--force-confdef"; "--force-confold" }' \
      >> /etc/apt/apt.conf.d/local
RUN apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y \
      cron \
      nano


RUN if([ ! -f /var/spoot/cron/crontabs/root ]|| \
      ( sudo ! grep --quiet 'mongodb_dump.sh' /var/spool/cron/crontabs/root )); \
    then \
      ( \
        echo ''; \
        echo '# Dump MongoDB for backup'; \
        echo '#'; \
        echo '15 3 * * * /app/mongodb_dump.sh'; \
        echo '15 11 * * * /app/mongodb_dump.sh'; \
        echo '15 19 * * * /app/mongodb_dump.sh'; \
      ) | tee -a /var/spool/cron/crontabs/root; \
    fi


# Prepare /app/ folder
#
WORKDIR /app/
COPY . .
