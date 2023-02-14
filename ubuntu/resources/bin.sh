#!/bin/bash

BASEDIR=${HOME}/.config/setup-ubuntu

mkdir -p "${BASEDIR}/bin"

TEXT="if [ -f ${BASEDIR}/.bashrc ]; then
            . ${BASEDIR}/.bashrc
        fi"

if grep -wq "${TEXT}" ~/.bashrc; then 
    echo "Exists" 

else 
    echo "Does not exist"
    echo "${TEXT}" >> ~/.bashrc
fi

cp -rf ./lib/bin/files/** ${BASEDIR}/bin

sudo cp -rf ./lib/bin/share/** /usr/bin
source ~/.bashrc