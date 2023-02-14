#!/bin/bash
source ./variables.sh $1 $2

echo "" > ~/.config/gtk-3.0/bookmarks
echo "file:///code/html dev" >> ~/.config/gtk-3.0/bookmarks 
echo "file:///usr/share/applications apps" >> ~/.config/gtk-3.0/bookmarks 


sudo chmod 777 /etc/xdg/user-dirs.conf

sudo echo "enabled=False" > /etc/xdg/user-dirs.conf
cat <<'EOF' > ~/.config/user-dirs.dirs
EOF
mkdir ~/.config/nautilus/ui
gresource extract /bin/nautilus \
          /org/gnome/nautilus/ui/nautilus-window.ui \
          > ~/.config/nautilus/ui/nautilus-window.ui
# export G_RESOURCE_OVERLAYS="/org/gnome/nautilus/ui=$HOME/.config/nautilus/ui"   
G_RESOURCE_OVERLAYS DEFAULT="/org/gnome/nautilus/ui=/home/confetti/.config/nautilus/ui"     
sudo chmod 777 /etc/xdg/user-dirs.defaults
sudo echo "" > /etc/xdg/user-dirs.defaults
sudo echo "DOWNLOAD=Downloads" >> /etc/xdg/user-dirs.defaults
sudo echo "DOCUMENTS=Documents" >> /etc/xdg/user-dirs.defaults


nautilus -q