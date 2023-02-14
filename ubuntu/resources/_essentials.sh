#!/bin/bash
source ./variables.sh $1 $2

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

