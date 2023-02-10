#!/bin/bash
source ./variables.sh $1 $2

sudo snap remove snap-store
sudo apt -y install gnome-software