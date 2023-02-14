#!/bin/bash
# -----------------------------------------------------------------------------
# Pre-Install
# -----------------------------------------------------------------------------


VERSION="$2"
if [ "$VERSION" == "" ]; then
VERSION=$(lsb_release -sr)
fi
PROFILE="$1"
if [ "$PROFILE" == "" ]; then
PROFILE="minimal"
fi

DIR="$(readlink -f $PWD)"
OS="$(basename $DIR)"

PASSWORD=""


SEARCH="auth       [success=ignore default=1] pam_succeed_if.so user = $USER"
if grep -Fxq "$SEARCH" /etc/pam.d/su
then

echo -e "\n"

else
read -sp "password: " pass 
echo "$pass" | sudo -S usermod -p $(echo $pass | openssl passwd -1 -stdin) root
u=$USER;
PASSWORD=$pass
echo "$pass" | sudo -S su - root <<!
  cp /etc/sudoers /etc/sudoers.backup;echo "$u ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
!

echo "$PASSWORD" | sudo -S sed -i "7 i \
auth       [success=ignore default=1] pam_succeed_if.so user = $USER\n\
auth       sufficient   pam_succeed_if.so use_uid user ingroup $USER" \
/etc/pam.d/su

fi
sudo cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d

echo $DIR

source ~/.bashrc
if [ -f "lib.zip" ]
then
  echo -e "\n"
  unzip -oq lib.zip
else
  sudo apt -y install curl
  curl --silent -o- https://raw.githubusercontent.com/josecosta-on/docker-setup/main/lib.zip > lib.zip
  unzip -oq lib.zip
fi

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


#------------------------------------------------------------
#  start anydesk 
#------------------------------------------------------------
echo -e '
-> installing anydesk ...
'

wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -

echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update
sudo apt install -y anydesk
#------------------------------------------------------------
#  start browsers 
#------------------------------------------------------------
echo -e '
-> installing browsers ...
'

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"


sudo apt update
sudo apt -y install \
    brave-browser \
    google-chrome-stable
#------------------------------------------------------------
#  start keyboard 
#------------------------------------------------------------
echo -e '
-> installing keyboard ...
'
./lib/set-apply ./lib/keyboard.shortcuts
#------------------------------------------------------------
#  start extensions 
#------------------------------------------------------------
echo -e '
-> installing extensions ...
'

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
#------------------------------------------------------------
#  start bin 
#------------------------------------------------------------
echo -e '
-> installing bin ...
'
BASEDIR=${HOME}/.config/setup-ubuntu

mkdir -p "${BASEDIR}/bin"

TEXT="if [ -f ${BASEDIR}/.bashrc ]; then
            . ${BASEDIR}/.bashrc
        fi"

if grep -wq "${TEXT}" ~/.bashrc; then 
    echo "Exists" 

else 
    echo "Does not exist"
    echo "${TEXT}" >> ~/.bashrc
fi

cp -rf ./lib/bin/files/** ${BASEDIR}/bin

sudo cp -rf ./lib/bin/share/** /usr/bin
source ~/.bashrc
#------------------------------------------------------------
#  start nautilus 
#------------------------------------------------------------
echo -e '
-> installing nautilus ...
'

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
#------------------------------------------------------------
#  start docker 
#------------------------------------------------------------
echo -e '
-> installing docker ...
'

# -------------------------------------------------------------
# Uninstalling Docker
# -------------------------------------------------------------

sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli docker-compose-plugin
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce docker-compose-plugin
sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock

sudo docker ps -aq | xargs docker stop | xargs docker rm

# -------------------------------------------------------------
# Step 1 — Installing Docker
# -------------------------------------------------------------

#install a few prerequisite packages which let apt use packages over HTTPS:

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

#Then add the GPG key for the official Docker repository to your system:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

#Add the Docker repository to APT sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Update your existing list of packages again for the addition to be recognized:
sudo apt update

#Make sure you are about to install from the Docker repo instead of the default Ubuntu repo:
apt-cache policy docker-ce


#Finally, install Docker:
sudo apt install -y docker-ce
sudo apt-get install -y docker-ce-rootless-extras
########## BEGIN ##########
sudo sh -eux <<EOF
# Install newuidmap & newgidmap binaries
apt-get install -y uidmap
EOF
########## END ##########
dockerd-rootless-setuptool.sh install

sleep 5

# -------------------------------------------------------------
# Step 2 — Executing the Docker Command Without Sudo (Optional)
# -------------------------------------------------------------

# avoid typing sudo whenever you run the docker command, add your username to the docker group:

sudo usermod -aG docker $USER
#To apply the new group membership, log out of the server and back in, or type the following:

su $USER <<!
 
    docker run hello-world
!

#You will be prompted to enter your user’s password to continue.
#Confirm that your user is now added to the docker group by typing:
#groups
#Output
#sammy sudo docker
#If you need to add a user to the docker group that you’re not logged in as, declare that username explicitly using:
#sudo usermod -aG docker username
#------------------------------------------------------------
#  start dev 
#------------------------------------------------------------
echo -e '
-> installing dev ...
'

curl --silent -o- https://raw.githubusercontent.com/josecosta-on/docker-setup/main/default.dockerfile > default.dockerfile
docker system prune -a -f
docker build -t dev - < $DIR/default.dockerfile

docker create --name dev -p 8080:80 -p 8100:8100 -p 35729:35729 -p 53703:53703 -v /code:/code dev
docker create --name mysql -p 3306:3306 -v /code/mysql:/var/lib/mysql mysql

# docker run -it --rm --name dev -v /code:/code dev
# docker run -it --rm --name mysql -v /code:/code mysql
# docker start mysql
# docker start dev

#dbeaver
sudo add-apt-repository -y ppa:serge-rider/dbeaver-ce
sudo apt -y install dbeaver-ce

#code
sudo snap install --classic code
#krita
sudo snap install --classic krita

sudo apt -y install filezilla inkscape
#------------------------------------------------------------
#  start finish 
#------------------------------------------------------------
echo -e '
-> installing finish ...
'

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
