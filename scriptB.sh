#!/bin/bash

NGINX_IP="127.0.0.1"  
NGINX_PORT="80"       

while true; do
    sleep $((RANDOM % 6 + 5))

    curl -i -X GET "http://$NGINX_IP:$NGINX_PORT/compute" > /dev/null 2>&1 &

    echo "HTTP request dispatched to nginx at $(date)"
done

