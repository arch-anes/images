#!/bin/sh

echo "Starting cron job"
start-stop-daemon --start --make-pidfile --background --pidfile /cron.pid --exec /cron.sh

echo "Starting nginx"
start-stop-daemon --start --make-pidfile --pidfile /nginx.pid --exec /usr/sbin/nginx

exec /entrypoint.sh "$@"
