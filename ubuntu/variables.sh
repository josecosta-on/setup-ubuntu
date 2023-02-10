#!/bin/bash

VERSION="$2"
if [ "$VERSION" == "" ]; then
VERSION=$(lsb_release -sr)
fi
PROFILE="$1"
if [ "$PROFILE" == "" ]; then
PROFILE="minimal"
fi

DIR="$(readlink -f $PWD)"
OS="$(basename $DIR)"

PASSWORD=""

read -sp "$OS password: " pass 
sudo usermod -p $(echo $pass | openssl passwd -1 -stdin) root
u=$USER;
PASSWORD=$pass
sudo su - root <<!
  cp /etc/sudoers /etc/sudoers.backup;echo "$u ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
!

SEARCH="auth       [success=ignore default=1] pam_succeed_if.so user = $USER"
if grep -Fxq "$SEARCH" /etc/pam.d/su
then

echo user in

else

sudo sed -i "7 i \
auth       [success=ignore default=1] pam_succeed_if.so user = $USER\n\
auth       sufficient   pam_succeed_if.so use_uid user ingroup $USER" \
/etc/pam.d/su

fi



echo $DIR