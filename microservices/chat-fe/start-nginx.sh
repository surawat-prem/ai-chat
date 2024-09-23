#!/bin/sh

# Replace placeholders in the default configuration
HOSTNAME=${HOST:-localhost}
PORT=${PORT:-80}

envsubst '$$HOSTNAME $$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start Nginx
nginx -g 'daemon off;'
