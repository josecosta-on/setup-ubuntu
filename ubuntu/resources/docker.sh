#!/bin/bash
source ./variables.sh $1 $2

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