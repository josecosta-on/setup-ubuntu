#!/bin/bash
source ./variables.sh $1 $2

I="$BASE_UNI_INSTALLER code --classic"
$(echo $I)

./lib/reader $0 default.txt "code --install-extension"

./lib/ubuntu/code-nautilus