#!/bin/bash
source ./variables.sh $1 $2

gsettings set org.gnome.shell app-picker-layout "[]"

gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"

notify-send 'Tudo pronto' \
 'Agora é contigo' 

if [ -d "/code" ]
then
    echo -e "code setup done\n"
else
    sudo cp -rf ./lib/code /code
    sudo chmod 777 -R /code
fi
