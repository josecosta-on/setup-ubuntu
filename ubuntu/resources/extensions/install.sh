sudo apt -y install gnome-shell-extensions
sudo apt -y install chrome-gnome-shell

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
