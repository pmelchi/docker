#!/bin/bash
#Although docker-compose is beatiful, it's problematic to run on swarm specific containers
#This script should help run the service on a specific host
docker run -d \
    --name pihole \
    --network host \
    -e TZ="America/Chicago" \
    -e ServerIP="10.0.1.102" \
    --mount source=vol-pihole,destination=/etc/pihole/ \
    --mount source=vol-pihole-dnsmasq,destination=/etc/dnsmasq.d/ \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=unless-stopped \
    pihole/pihole:latest

printf 'Starting up pihole container '
for i in $(seq 1 20); do
    if [ "$(docker inspect -f "{{.State.Health.Status}}" pihole)" == "healthy" ] ; then
        printf ' OK'
        echo -e "\n$(docker logs pihole 2> /dev/null | grep 'password:') for your pi-hole: https://${IP}/admin/"
        exit 0
    else
        sleep 3
        printf '.'
    fi

    if [ $i -eq 20 ] ; then
        echo -e "\nTimed out waiting for Pi-hole start, consult check your container logs for more info (\`docker logs pihole\`)"
        exit 1
    fi
done;