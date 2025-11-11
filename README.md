# Terraform Demo: ECS Fargate - Postgres(public)

## Terraform - Deploy

```sh
cd aws

terraform init -backend-config=backend.config
terraform fmt && terraform validate

terraform apply -auto-approve
# Outputs:
# cdn_domain = "d19tn7iec1lu1l.cloudfront.net"

terraform destroy -auto-approve
```

---

## Connect with PGAdmin 4

![pic](./doc/connect_pg.png)

- Connect exec

```sh
aws ecs describe-services --cluster demo-ecs-postgres-cluster --service demo-ecs-postgres-db-service --region ca-central-1
# "enableExecuteCommand": true

# ??
aws ecs execute-command --cluster demo-ecs-postgres-cluster --task 9edb6dfe7b114ed4b9131d44352a83da --container postgres --interactive --command '/bin/sh'

```
