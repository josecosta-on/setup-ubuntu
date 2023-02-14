#!/bin/bash

# -----------------------------------------------------------------------------
# Pre-Install
# -----------------------------------------------------------------------------


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


SEARCH="auth       [success=ignore default=1] pam_succeed_if.so user = $USER"
if grep -Fxq "$SEARCH" /etc/pam.d/su
then

echo -e "\n"

else
read -sp "password: " pass 
echo "$pass" | sudo -S usermod -p $(echo $pass | openssl passwd -1 -stdin) root
u=$USER;
PASSWORD=$pass
echo "$pass" | sudo -S su - root <<!
  cp /etc/sudoers /etc/sudoers.backup;echo "$u ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
!

echo "$PASSWORD" | sudo -S sed -i "7 i \
auth       [success=ignore default=1] pam_succeed_if.so user = $USER\n\
auth       sufficient   pam_succeed_if.so use_uid user ingroup $USER" \
/etc/pam.d/su

fi
sudo cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d

echo $DIR

source ~/.bashrc