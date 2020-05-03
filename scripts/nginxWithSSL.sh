#!/bin/bash

checkEnvironment() {
    #Check if the required environment exist
    echo "Remember to add LETSENCRYPT_EMAIL"
}

runNginx() {
    docker run --detach \
        --name nginx-proxy \
        --publish 8080:80 \
        nginx:latest
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
#runLetsEncrypt