#!/bin/bash

#Set your own nextcloud storage path
NEXTCLOUD_STORAGE=/nextcloud

docker network create -d overlay nextcloud-network

#Secrets are only available inside a swarm (which can also be standalone)
docker run -d \
    --name nextcloud-db \
    -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/NEXTCLOUD_MYSQL_ROOT_PASSWORD \
    -e MYSQL_PASSWORD_FILE=/run/secrets/NEXTCLOUD_MYSQL_PASSWORD \
    -e MYSQL_DATABASE_FILE=/run/secrets/NEXTCLOUD_MYSQL_DATABASE \
    -e MYSQL_USER_FILE=/run/secrets/NEXTCLOUD_MYSQL_USER \
    --mount type=bind,source={$NEXTCLOUD_STORAGE}/mysql,target=/var/lib/mysql \
    --network=nextcloud-network
    mariadb:tag \
    --transaction-isolation=READ-COMMITTED \
    --binlog-format=ROW