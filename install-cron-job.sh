#!/bin/sh

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"

    exit
fi

mkdir -u /root/cron-logs

echo "0 5 * * * cd /root/telegram-proxy && ./proxy.sh restart >> /root/cron-logs/telegram-proxy.log" >> /etc/cron.d/restart-telegram-proxy

