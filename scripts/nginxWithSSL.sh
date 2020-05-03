#!/bin/bash

checkEnvironment() {
    #Check if the required environment exist
    echo "Remember to add LETSENCRYPT_EMAIL"
}

runNginx() {
    docker run --detach \
        --name nginx-proxy \
        --publish 80:80 \
        --publish 443:443 \
        --volume /etc/nginx/certs \
        --volume /etc/nginx/vhost.d \
        --volume /usr/share/nginx/html \
        --volume /var/run/docker.sock:/tmp/docker.sock:ro \
        jwilder/nginx-proxy
}

runLetsEncrypt() {
    echo "You are emailing to: ${LETSENCRYPT_EMAIL}"
    docker run --detach \
        --name nginx-proxy-letsencrypt \
        --volumes-from nginx-proxy \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --env "DEFAULT_EMAIL=${LETSENCRYPT_EMAIL}" \
        jrcs/letsencrypt-nginx-proxy-companion    
}

checkEnvironment
runNginx
runLetsEncrypt