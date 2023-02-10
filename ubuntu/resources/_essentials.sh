#!/bin/bash

source ./variables.sh $1 $2

echo " -> Setup $OS $VERSION - $PROFILE";
echo " -----------------------------------------------------------";
sudo apt -y install notify-osd
notify-send 'Vamos começar' \
 'Tome um café e aguarde' --icon=dialog-information

read -sp 'ubuntu password: ' pass 
sudo usermod -p $(echo $pass | openssl passwd -1 -stdin) root
u=$USER;

sudo su - root <<!
  cp /etc/sudoers /etc/sudoers.backup;echo "$u ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
!

sudo apt -y install build-essential
sudo cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d
sudo apt -y install git
git config --global core.filemode true

