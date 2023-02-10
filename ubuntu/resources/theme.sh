#!/bin/bash
source ./variables.sh $1 $2

gsettings set org.gnome.desktop.wm.preferences button-layout ':close'
