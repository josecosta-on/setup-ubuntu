#!/bin/bash
source ./variables.sh $1 $2

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