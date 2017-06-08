FROM nginx:mainline-alpine

apk add --update bash

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["/docker-entrypoint.sh"]
