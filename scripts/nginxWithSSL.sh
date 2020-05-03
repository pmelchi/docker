#!/bin/bash

checkEnvironment() {
    #Check if the required environment exist
    echo "Nothing to check"
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
    docker run --detach \
        --name nginx-proxy-letsencrypt \
        --volumes-from nginx-proxy \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --env "DEFAULT_EMAIL=mail@yourdomain.tld" \
        jrcs/letsencrypt-nginx-proxy-companion    
}

checkEnvironment()
runNginx()
runLetsEncrypt()