#!/bin/sh

# Replace placeholders in the default configuration
HOSTNAME=${HOST:-localhost}
PORT=${PORT:-80}
CHAT_SERVER_SOCKET_URL=${CHAT_SERVER_SOCKET_URL:-localhost}

envsubst '$$CHAT_SERVER_SOCKET_URL' < /usr/share/nginx/html/index.html > /usr/share/nginx/html/index.html.tmp \
  && mv /usr/share/nginx/html/index.html.tmp /usr/share/nginx/html/index.html

envsubst '$$HOSTNAME $$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start Nginx
nginx -g 'daemon off;'
