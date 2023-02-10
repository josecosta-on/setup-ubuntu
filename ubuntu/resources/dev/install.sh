#!/bin/bash
source ./variables.sh $1 $2

# docker system prune -a -f

# docker build -t dev - < $DIR/resources/dev/dockers/default.dockerfile
# docker build -t php - < $DIR/resources/dev/dockers/php.dockerfile
# docker build -t node - < $DIR/resources/dev/dockers/node.dockerfile
docker build -t ionic3 - < $DIR/resources/dev/dockers/ionic3.dockerfile

# docker create dev --name dev
# docker create php --name php
# docker create node --name node
docker create ionic3 --name ionic

# docker run -it --rm --name dev dev
# docker run -it --rm --name php php
# docker run -it --rm --name node node