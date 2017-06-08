#!/bin/sh
echo $NGINX_HTPASSWD > /etc/nginx/htpasswd
exec /usr/sbin/nginx "-g daemon off;"
