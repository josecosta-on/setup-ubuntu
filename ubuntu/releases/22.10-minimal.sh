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
if [ -f "lib.zip" ]
then
  echo -e "\n"
  unzip -oq lib.zip
else
  sudo apt -y install curl
  curl --silent -o- https://raw.githubusercontent.com/josecosta-on/docker-setup/main/lib.zip > lib.zip
  unzip -oq lib.zip
fi

# -----------------------------------------------------------------------------
# Pre-Install
# -----------------------------------------------------------------------------



#replace ubuntu store
sudo snap remove snap-store

# -----------------------------------------------------------------------------
# Install
# -----------------------------------------------------------------------------

sudo apt -y install \
  build-essential \
  notify-osd \
  git \
  curl \
  gnome-tweaks \
  gnome-software \
  flatpak

# -----------------------------------------------------------------------------
# Post-install
# -----------------------------------------------------------------------------
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
git config --global core.filemode true
git config --global http.sslVerify false # Do NOT do this!
sudo flatpak install -y flathub com.mattjakeman.ExtensionManager

echo " -> Setup $OS $VERSION - $PROFILE";
echo " -----------------------------------------------------------";


# -----------------------------------------------------------------------------
# First setup
# -----------------------------------------------------------------------------

notify-send 'Vamos começar' \
 'Tome um café e aguarde' 


#------------------------------------------------------------
#  start extensions 
#------------------------------------------------------------
echo -e '
-> installing extensions ...
'

GNOME_SHELL_VERSION=43
sudo apt -y install \
    gnome-shell-extensions \
    chrome-gnome-shell

./lib/extensions/install \
    906:sound-output-device-chooser:$GNOME_SHELL_VERSION \
    19:user-themes: \
    4158:gnome-40-ui-improvements:$GNOME_SHELL_VERSION \
    3100:maximize-to-empty-workspace:$GNOME_SHELL_VERSION \
    1160:dash-to-panel:$GNOME_SHELL_VERSION \
    4167:custom-hot-corners-extended:$GNOME_SHELL_VERSION

