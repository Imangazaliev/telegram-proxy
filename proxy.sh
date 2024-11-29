#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"

    exit
fi

# example: DEBUG=1 ./proxy.sh status
if test -n "$DEBUG"; then
    echo "Debug enabled"

    set -e -x
fi

CURRENT_DIR=$(dirname $(realpath $0))

source "$CURRENT_DIR/utils.sh"

load_env '='

COMMAND="$1"
DEFAULT_CONTAINER_NAME="mtproto-proxy"
CONTAINER_NAME="${CONTAINER_NAME:=$DEFAULT_CONTAINER_NAME}"
DEFAULT_PORT=443
PORT="${PORT:=$DEFAULT_PORT}"

# удаляем первый аргумент
shift

proxy_status()
{
    MTPROTO_CONTAINER=$(docker ps -a --format "{{.Names}}" | grep -Fx "$CONTAINER_NAME")
    if [[ "$MTPROTO_CONTAINER" = "$CONTAINER_NAME" ]]
    then
        docker ps -a --filter "name=$CONTAINER_NAME" --format "{{.State}}: {{.Status}} — {{.ID}}"
    else
        echo "Container doesn't exist"
    fi
}

proxy_start()
{
    docker run -d "-p$PORT:443" \
        --name="$CONTAINER_NAME" \
        --restart=always \
        -v proxy-config:/data \
        -e "TAG=$TAG" \
        -e "SECRET=$SECRET" \
        telegrammessenger/proxy:latest

    echo "Proxy started!"
}

proxy_stop()
{
    docker container stop "$CONTAINER_NAME"

    echo "Proxy container stopped!"
}

proxy_remove()
{
    docker container rm "$CONTAINER_NAME"

    echo "Proxy container removed!"
}

if [ "$COMMAND" = "status" ]; then
    proxy_status "$@"
elif [ "$COMMAND" = "start" ]; then
    proxy_start "$@"
elif [ "$COMMAND" = "stop" ]; then
    proxy_stop
elif [ "$COMMAND" = "remove" ]; then
    proxy_remove
elif [ "$COMMAND" = "restart" ]; then
    proxy_stop && proxy_remove && proxy_start "$@"
elif [ "$COMMAND" = "logs" ]; then
    docker logs "$CONTAINER_NAME"
else
    echo "Unknown command \"$COMMAND\""
fi

