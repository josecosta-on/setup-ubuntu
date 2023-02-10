FROM dev
LABEL maintainer="José Costa"

# ARGS
ARG NODE_VERSION='14'


# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV BUILD_NODE_VERSION=$NODE_VERSION

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN add-apt-repository universe
# update the repository sources list
# and install dependencies
RUN apt-get update \
    && apt-get install -y curl \
    && apt-get -y autoclean


RUN apt-get update && apt-get install -y build-essential libssl-dev \
	python3 gnupg2

RUN mkdir -p $NVM_DIR
# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash


# install node and npm LTS
RUN source $NVM_DIR/nvm.sh \
    && nvm install $BUILD_NODE_VERSION \
    && nvm alias default $BUILD_NODE_VERSION \
    && nvm use default \
    && nvm install 8.1.3 \
    && nvm use 8.1.3

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$BUILD_NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$BUILD_NODE_VERSION/bin:$PATH

RUN source $HOME/.profile
# # confirm installation of node
# RUN ["/bin/bash", "-c", "node -v"]
# RUN ["/bin/bash", "-c", "npm -v"]

# Force bash as shell
# RUN ["/bin/bash", "-c", "echo hello all in one string"]

CMD ["bash", "-l"]