#!/bin/bash
source ./variables.sh $1 $2

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

# dconf dump /org/gnome/shell/extensions/$name/ > ./lib/extensions/config/$name.dconf