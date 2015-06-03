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
    apt-get upgrade -y


# Prepare /app/ folder
#
WORKDIR /app/
COPY . .
