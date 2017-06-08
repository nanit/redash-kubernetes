FROM nginx:mainline-alpine

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["/docker-entrypoint.sh"]
