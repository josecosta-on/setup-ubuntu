#!/bin/bash
source ./variables.sh $1 $2

gsettings set org.gnome.shell app-picker-layout "[]"

gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"

notify-send 'Tudo pronto' \
 'Agora é contigo' 

if [ -d "/code" ]
then
    echo -e "code done\n"
else
    mkdir -p  {"/code/html","/code/logs","/code/mysql","/code/nvm"}
   
fi
