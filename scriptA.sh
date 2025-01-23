#!/bin/bash

check_container_busy() {
    container=$1
    # Get container CPU usage
    usage=$(docker stats --no-stream --format "{{.CPUPerc}}" "$container" 2>/dev/null | sed 's/%//')
    if [ -z "$usage" ]; then
        echo "idle"  # Container is idle
        return
    fi
    usage=${usage%%.*}  # Convert usage to an integer
    if [ "$usage" -gt 80 ]; then
        echo "busy"
    else
        echo "idle"
    fi
}

launch_container() {
    container=$1
    core=$2
    echo "Launching $container on CPU core $core"
    docker run -d --cpuset-cpus="$core" -p 8081 --name "$container" cloudysommme/my-http-server
    ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container")
    echo "Container $container launched with IP $ip"
    update_nginx_config "$container" "$ip"
}


terminate_container() {
    container=$1
    echo "Terminating $container"
    remove_nginx_config "$container"
    docker stop "$container" && docker rm "$container"
}


update_nginx_config() {
    container=$1
    ip=$2
    echo "Adding $container with IP $ip to Nginx config"
    sudo sed -i "/upstream app {/a\    server $ip:8081;" /etc/nginx/nginx.conf
    sudo nginx -s reload
}

remove_nginx_config() {
    container=$1
    ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container")
    echo "Removing $container with IP $ip from Nginx config"
    sudo sed -i "/server $ip:8081;/d" /etc/nginx/nginx.conf
    sudo nginx -s reload
}

update_container() {
    container=$1
    echo "Updating $container"
    docker stop "$container"
    docker rm "$container"
    launch_container "$container" "${container: -1}"
}

# Main loop
while true; do
    echo "Starting a new iteration of the main loop"

    # Check if srv1 is running
    if ! docker ps --filter "name=srv1" | grep -q "srv1"; then
        echo "srv1 is not running, starting"
        launch_container srv1 0
    fi

    # Check and terminate srv1 if it has been idle for 30 seconds
    if docker ps --filter "name=srv1" | grep -q "srv1"; then
        echo "Checking if srv1 is idle"
        if [ "$(check_container_busy srv1)" == "idle" ]; then
            echo "srv1 is idle, waiting 30 seconds before terminating"
            sleep 30
            # Check again after 30 seconds
            if [ "$(check_container_busy srv1)" == "idle" ]; then
                echo "srv1 is still idle, terminating"
                terminate_container srv1
            else
                echo "srv1 is no longer idle, skipping termination"
            fi
        fi
    else
        echo "srv1 is not running, skipping idle check"
    fi

    # Start srv2 after 15 seconds if srv1 is busy
    if docker ps --filter "name=srv1" | grep -q "srv1"; then
        echo "srv1 is running, checking if srv2 should be started"
        if [ "$(check_container_busy srv1)" == "busy" ]; then
            sleep 30
            if ! docker ps --filter "name=srv2" | grep -q "srv2"; then
                echo "Starting srv2"
                launch_container srv2 1
            fi
        fi
    fi

    # Start srv3 after 15 seconds if srv2 is busy
    if docker ps --filter "name=srv2" | grep -q "srv2"; then
        echo "srv2 is running, checking if srv3 should be started"
        if [ "$(check_container_busy srv2)" == "busy" ]; then
            sleep 30
            if ! docker ps --filter "name=srv3" | grep -q "srv3"; then
                echo "Starting srv3"
                launch_container srv3 2
            fi
        fi
    fi

    # Check and terminate srv2 if it has been idle for 30 seconds
    if docker ps --filter "name=srv2" | grep -q "srv2"; then
        echo "Checking if srv2 is idle"
        if [ "$(check_container_busy srv2)" == "idle" ]; then
            echo "srv2 is idle, waiting 30 seconds before terminating"
            sleep 30
            # Check again after 30 seconds
            if [ "$(check_container_busy srv2)" == "idle" ]; then
                echo "srv2 is still idle, terminating"
                terminate_container srv2
            else
                echo "srv2 is no longer idle, skipping termination"
            fi
        fi
    else
        echo "srv2 is not running, skipping idle check"
    fi

    # Check and terminate srv3 if it has been idle for 30 seconds (only after srv2 is terminated)
    if ! docker ps --filter "name=srv2" | grep -q "srv2"; then
        if docker ps --filter "name=srv3" | grep -q "srv3"; then
            echo "Checking if srv3 is idle"
            if [ "$(check_container_busy srv3)" == "idle" ]; then
                echo "srv3 is idle, waiting 30 seconds before terminating"
                sleep 30
                # Check again after 30 seconds
                if [ "$(check_container_busy srv3)" == "idle" ]; then
                    echo "srv3 is still idle, terminating"
                    terminate_container srv3
                else
                    echo "srv3 is no longer idle, skipping termination"
                fi
            fi
        else
            echo "srv3 is not running, skipping idle check"
        fi
    fi

    # Check for a new image version and update containers
    echo "Fetching the latest image..."
    output=$(docker pull cloudysommme/my-http-server:latest)
    echo "$output"  # Output for debugging

    # Check if a newer image was downloaded
    if echo "$output" | grep -q "Downloaded newer image"; then
        echo "New image found, updating containers..."
        for container in srv1 srv2 srv3; do
            if docker ps --filter "name=$container" | grep -q "$container"; then
                update_container $container
            fi
        done
    else
        echo "No new image found, skipping update."
    fi

    sleep 30
done

