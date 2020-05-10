#!/bin/bash

 NEXTCLOUD_STORAGE=/

docker volume 

docker run -d \
    --name nextcloud-db \
    -e MYSQL_ROOT_PASSWORD=my-secret-pw \
    mariadb:tag