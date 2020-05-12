#!/bin/bash

#Set your own nextcloud storage path
NEXTCLOUD_STORAGE=/nextcloud

docker network create -d overlay --attachable nextcloud-network
docker network create -d overlay --attachable nextcloud-proxy-network

#Path to "${NEXTCLOUD_STORAGE}/mysql" must exist
#env.list file must be updated with your values
docker run -d \
    --name nextcloud-db \
    --env-file=env.list \
    --mount type=bind,source="${NEXTCLOUD_STORAGE}/mysql",target=/var/lib/mysql \
    --network=nextcloud-network \
    --restart=unless-stopped \
    mariadb:latest \
    --transaction-isolation=READ-COMMITTED \
    --binlog-format=ROW

#Running nextcloud app/fpm
docker run -d \
    --name nextcloud-app \
    -e MYSQL_HOST=nextcloud-db \
    --env-file=env.list \
    --mount type=bind,source="${NEXTCLOUD_STORAGE}/html",target=/var/www/html \
    --network=nextcloud-network \
    --restart=unless-stopped \
    nextcloud:fpm-alpine