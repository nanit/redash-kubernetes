REDASH_NAME=redash
REDASH_FOLDER=app
REDASH_IMAGE_TAG=$(shell git log -n 1 --pretty=format:%h $(REDASH_FOLDER))
REDASH_IMAGE_NAME=nanit/$(REDASH_NAME):$(REDASH_IMAGE_TAG)
DB_URL?=$(shell curl -s config/$(NANIT_ENV)/$(REDASH_NAME)/db_url)

NGINX_NAME=$(REDASH_NAME)-nginx
NGINX_FOLDER=nginx
NGINX_IMAGE_TAG=$(shell git log -n 1 --pretty=format:%h $(NGINX_FOLDER))
NGINX_IMAGE_NAME=nanit/$(NGINX_NAME):$(NGINX_IMAGE_TAG)
NGINX_HTPASSWD=$(shell curl -s config/$(NANIT_ENV)/$(REDASH_NAME)/htpasswd)

define generate-dep
	if [ -z "$(DB_URL)" ]; then echo "ERROR: DB_URL is empty!"; exit 1; fi
	sed -e 's/{{NGINX_APP_NAME}}/$(NGINX_NAME)/g;s,{{DB_URL}},$(DB_URL),g;s/{{REDASH_APP_NAME}}/$(REDASH_NAME)/g;s,{{REDASH_IMAGE_NAME}},$(REDASH_IMAGE_NAME),g;s,{{NGINX_IMAGE_NAME}},$(NGINX_IMAGE_NAME),g' kube/dep.yml
endef

define generate-svc
	sed -e 's/{{APP_NAME}}/$(REDASH_NAME)/g;s/{{SVC_NAME}}/$(REDASH_NAME)/g' kube/svc.yml
endef

deploy: docker
	$(call generate-dep) | kubectl apply -f -
	kubectl get svc $(REDASH_NAME) || $(call generate-svc) | kubectl create -f -

docker: docker-redash docker-nginx

docker-redash:
	sudo docker pull $(REDASH_IMAGE_NAME) || (sudo docker build -t $(REDASH_IMAGE_NAME) $(REDASH_FOLDER) && sudo docker push $(REDASH_IMAGE_NAME))

docker-nginx:
	if [ -z "$(NGINX_HTPASSWD)" ]; then echo "ERROR: NGINX_HTPASSWD is empty!"; exit 1; fi
	echo $(NGINX_HTPASSWD) > nginx/htpasswd
	sudo docker pull $(NGINX_IMAGE_NAME) || (sudo docker build -t $(NGINX_IMAGE_NAME) $(NGINX_FOLDER) && sudo docker push $(NGINX_IMAGE_NAME))

