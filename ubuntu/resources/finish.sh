#!/bin/bash
source ./variables.sh $1 $2

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