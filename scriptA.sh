#!/bin/bash

check_container_busy() {
    container=$1
    usage=$(docker stats --no-stream --format "{{.CPUPerc}}" "$container" 2>/dev/null | sed 's/%//')
    if [ -z "$usage" ]; then
        echo "idle"
        return
    fi
    usage=${usage%%.*}
    if [ "$usage" -gt 80 ]; then
        echo "busy"
    else
        echo "idle"
    fi
}

launch_container() {
    container=$1
    core=$2
    echo "Запуск $container на CPU ядрі $core"
    docker run -d --cpuset-cpus="$core" --name "$container" cloudysommme/my-http-server
}

terminate_container() {
    container=$1
    echo "Завершення $container"
    docker stop "$container" && docker rm "$container"
}

update_container() {
    container=$1
    echo "Оновлення $container"
    docker stop "$container"
    docker rm "$container"
    launch_container "$container" "${container: -1}"
}

while true; do
    echo "Початок нової ітерації головного циклу"

    if ! docker ps --filter "name=srv1" | grep -q "srv1"; then
        echo "srv1 не працює, запускаємо"
        launch_container srv1 0
    fi

    if docker ps --filter "name=srv1" | grep -q "srv1"; then
        echo "Перевіряємо, чи srv1 простоює"
        if [ "$(check_container_busy srv1)" == "idle" ]; then
            echo "srv1 простоює, очікуємо 30 секунд перед завершенням"
            sleep 30
            if [ "$(check_container_busy srv1)" == "idle" ]; then
                echo "srv1 все ще простоює, завершуємо"
                terminate_container srv1
            else
                echo "srv1 більше не простоює, пропускаємо завершення"
            fi
        fi
    fi

    if docker ps --filter "name=srv1" | grep -q "srv1"; then
        echo "srv1 працює, перевіряємо, чи srv2 має бути запущений"
        if [ "$(check_container_busy srv1)" == "busy" ]; then
            sleep 30
            if ! docker ps --filter "name=srv2" | grep -q "srv2"; then
                echo "Запуск srv2"
                launch_container srv2 1
            fi
        fi
    fi

    if docker ps --filter "name=srv2" | grep -q "srv2"; then
        echo "srv2 працює, перевіряємо, чи srv3 має бути запущений"
        if [ "$(check_container_busy srv2)" == "busy" ]; then
            sleep 30
            if ! docker ps --filter "name=srv3" | grep -q "srv3"; then
                echo "Запуск srv3"
                launch_container srv3 2
            fi
        fi
    fi

    if docker ps --filter "name=srv2" | grep -q "srv2"; then
        echo "Перевіряємо, чи srv2 простоює"
        if [ "$(check_container_busy srv2)" == "idle" ]; then
            echo "srv2 простоює, очікуємо 30 секунд перед завершенням"
            sleep 30
            if [ "$(check_container_busy srv2)" == "idle" ]; then
                echo "srv2 все ще простоює, завершуємо"
                terminate_container srv2
            else
                echo "srv2 більше не простоює, пропускаємо завершення"
            fi
        fi
    fi

    if ! docker ps --filter "name=srv2" | grep -q "srv2"; then
        if docker ps --filter "name=srv3" | grep -q "srv3"; then
            echo "Перевіряємо, чи srv3 простоює"
            if [ "$(check_container_busy srv3)" == "idle" ]; then
                echo "srv3 простоює, очікуємо 30 секунд перед завершенням"
                sleep 30
                if [ "$(check_container_busy srv3)" == "idle" ]; then
                    echo "srv3 все ще простоює, завершуємо"
                    terminate_container srv3
                else
                    echo "srv3 більше не простоює, пропускаємо завершення"
                fi
            fi
        fi
    fi

    echo "Отримуємо останню версію образу..."
    output=$(docker pull cloudysommme/my-http-server:latest)
    echo "$output"

    if echo "$output" | grep -q "Downloaded newer image"; then
        echo "Знайдено новий образ, оновлюємо контейнери..."
        for container in srv1 srv2 srv3; do
            if docker ps --filter "name=$container" | grep -q "$container"; then
                update_container $container
            fi
        done
    fi

    sleep 30
done

