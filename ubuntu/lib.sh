#!/bin/bash


if [ -f "lib.zip" ]
then
  echo -e "\n"
  unzip -oq lib.zip
else
  sudo apt -y install curl
  curl --silent -o- https://raw.githubusercontent.com/josecosta-on/docker-setup/main/lib.zip > lib.zip
  unzip -oq lib.zip
fi
