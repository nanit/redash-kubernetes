#!/bin/bash
echo $NGINX_HTPASSWD > /etc/nginx/htpasswd
exec nginx
