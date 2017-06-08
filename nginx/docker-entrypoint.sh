echo $NGINX_HTPASSWD > /etc/nginx/htpasswd
exec nginx -g daemon off;
