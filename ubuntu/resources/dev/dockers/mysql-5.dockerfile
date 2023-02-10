FROM dev:22.04
LABEL maintainer="José Costa"

# ARGS
ARG PHP_VERSION='7.3'

# Envs
ENV TZ="UTC"
ENV WEBHOME="/var/www/html"

ENV BUILD_PHP_VERSION=$PHP_VERSION \
    DEBIAN_FRONTEND=noninteractive \
    WEBUSER_HOME="/var/www/html" \
    PUID=9999 \
    PGID=9999


RUN add-apt-repository -y ppa:ondrej/php

RUN apt install -y php${BUILD_PHP_VERSION}
