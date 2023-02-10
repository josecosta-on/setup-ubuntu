#!/bin/bash
source ./variables.sh $1 $2

I="$BASE_INSTALLER mysql-server"
$(echo $I)

echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'root';"|sudo mysql
echo "FLUSH PRIVILEGES;"|mysql -u root  -proot