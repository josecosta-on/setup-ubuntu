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


#------------------------------------------------------------
#  start chrome 
#------------------------------------------------------------
echo -e '
-> installing chrome ...
'


wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
sudo apt install google-chrome-stable


#------------------------------------------------------------
#  start theme 
#------------------------------------------------------------
echo -e '
-> installing theme ...
'

gsettings set org.gnome.desktop.wm.preferences button-layout ':close'

#------------------------------------------------------------
#  start store 
#------------------------------------------------------------
echo -e '
-> installing store ...
'

sudo snap remove snap-store
sudo apt -y install gnome-software
#------------------------------------------------------------
#  start fav 
#------------------------------------------------------------
echo -e '
-> installing fav ...
'

gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"
#------------------------------------------------------------
#  start keyboard/install 
#------------------------------------------------------------
echo -e '
-> installing keyboard/install ...
'

CHECK=$(echo $CHECK | tr "[:upper:]" "[:lower:]")
echo $CHECK

if [ "$CHECK" == "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" ]; then

    gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Primary><Alt>t']"
    python3 ./lib/keyboard.py 'open nautilus' 'nautilus' '<Super>e'
    python3 ./lib/keyboard.py 'open sudo nautilus' 'sudo nautilus' '<Alt>e'


fi
   ./lib/set-apply keyboard
#------------------------------------------------------------
#  start extensions/install 
#------------------------------------------------------------
echo -e '
-> installing extensions/install ...
'

#gsconnect
# ./lib/ext-manager --install --extension-id 1319
#panel osd
# ./lib/ext-manager --install --extension-id 708

#sound input & output device chooser - considerar substituto
./lib/ext-manager --install --extension-id 906
./lib/ext-run sound-output-device-chooser
./lib/ext-apply sound-output-device-chooser


#tweak in system menu
# ./lib/ext-manager --install --extension-id 1653
#removable drive menu
# ./lib/ext-manager --install --extension-id 7
#miniview
# ./lib/ext-manager --install --extension-id 1459 --version 3.34
# ./lib/ext-run miniview
# ./lib/ext-apply miniview
#user themes
./lib/ext-manager --install --extension-id 19
#Gnome 4x UI Improvements
./lib/ext-manager --install --extension-id 4158
#Maximize To Empty Workspace
./lib/ext-manager --install --extension-id 3100

#dash to panel
./lib/ext-manager --install --extension-id 1160
./lib/ext-run dash-to-panel
./lib/ext-apply dash-to-panel 2>/dev/null

#custom hot corners
./lib/ext-manager --install --extension-id 4167
./lib/ext-run custom-hot-corners
./lib/ext-apply custom-hot-corners 2>/dev/null

gsettings set org.gnome.shell.extensions.dash-to-dock isolate-locations false

#dash to dock
# ./lib/ext-manager --install --extension-id 307
# ./lib/ext-run dash-to-dock
# ./lib/ext-apply dash-to-dock 2>/dev/null

#------------------------------------------------------------
#  start bin/install 
#------------------------------------------------------------
echo -e '
-> installing bin/install ...
'
if ! [ "$EXPORTED" == "export PATH" ]; then
    echo path not added
    echo 'export PATH=${PATH}:${HOME}/.bin' >> ~/.bashrc
    ln -s ~/setup-ubuntu/resources/bin/files ~/.bin
fi

sudo cp -rf ~/setup-ubuntu/resources/bin/share/** /usr/bin
source ~/.bashrc
#------------------------------------------------------------
#  start php/install 
#------------------------------------------------------------
echo -e '
-> installing php/install ...
'
CHECK=$(php --version | awk '{print substr($0,1,4);exit}')

CHECK=$(echo $CHECK | tr "[:upper:]" "[:lower:]")
echo $CHECK

# PHPV="php7.1"
# PHPV="php7.2"
PHPV="php7.3"
# PHPV="php7.4"
# PHPV="php8.0"
IFS=$'\n';
for x in $(ls -1 -d /etc/apache2/mods-enabled/php*.conf) ;do
    FILE=${x//"/etc/apache2/mods-enabled/"/""}
    v=${FILE//".conf"/""}
    sudo a2dismod $v
done

sudo add-apt-repository -y ppa:ondrej/php
sudo apt -y install $PHPV
sudo apt-get -o Dpkg::Options::="--force-overwrite" install libpcre2-posix2
sudo update-alternatives --set php /usr/bin/$PHPV
sudo a2enmod $PHPV
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf $PHPV-fpm

./lib/reader $0 php-default.txt "sudo apt install -y"
echo "######################### installing $PHPV ##############################"
./lib/reader $0 php.txt "./php $PHPV"
./lib/reader $0 php-base.txt "./php php"
sudo apt autoremove -y
sudo systemctl restart apache2

#------------------------------------------------------------
#  start finish 
#------------------------------------------------------------
echo -e '
-> installing finish ...
'

sudo rm -rf ~/.config/setup-ubuntu
sudo cp ./lib/custom /usr/share/custom
sudo cp ./lib/notify /usr/share/notify
sudo cp ./lib/customboot /usr/bin/customboot
sudo cp ./lib/custom-boot.desktop /usr/share/applications/custom-boot.desktop

sudo rm /etc/systemd/user/custom.service
sudo cp ./lib/custom.service /etc/systemd/user/custom.service

systemctl --user disable custom
systemctl --user daemon-reload
systemctl --user enable custom

gsettings set org.gnome.shell app-picker-layout "[]"
sudo apt -y install gnome-tweaks
./lib/restart-shell
exit 0;