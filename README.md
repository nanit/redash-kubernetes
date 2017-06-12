# Redash Setup For Kubernetes

If you arrived here, you probably know what Redash is.

If not, you're more than welcome [to get yourself familiar with it](https://github.com/getredash/redash).

# Prerequsites:

1. A working K8s cluster
2. kubectl configured to work against your cluster
3. A crypted htpasswd string for the web interface's basic auth
4. A Docker repository you are able to push and pull images from
5. A PostgreSQL database URL with the redash database (not schema, only database) already created.

# Deployment

1. Clone this repository: `git clone --recursive git@github.com:nanit/redash-kubernetes.git`

2. Run the deployment task from the makefile:

```
DOCKER_REPO=my_company_docker_repo \
REDASH_DATABASE_URL=postgres://redash-user@postgres/redash-db \
REDASH_NAME=my-redash \
REDASH_HOST=my-redash.my-company.com \
REDASH_MAIL_SERVER=my.smtp.com \
REDASH_MAIL_PORT=587 \
REDASH_MAIL_USERNAME=smtp-user \
REDASH_MAIL_PASSWORD=smtp-password \
REDASH_MAIL_DEFAULT_SENDER=my-redash@my-company.com \
NGINX_HTPASSWD=my-user:some-crypted-password
make deploy
```

3. When the redash pod is ready run create_db in order to create the DB schema.
List your redash pods: `kubectl get pods -l app=redash`
Then run the command on the pod:
`kubectl exec redash-3940390882-13xgl -c redash-web -- /app/bin/docker-entrypoint create_db`
Just replace `redash-3940390882-13xgl` with your actual pod name

# Usage

1. Get the ELB hostname which is serving Redash:
`kubectl get service redash -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"`

2. Put it into the browser and insert the credentials you've set in your htpasswd file

That's it, you're in.


