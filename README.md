# Terraform Demo: ECS Fargate - Postgres(public)

## Terraform - Deploy

```sh
cd aws

terraform init -backend-config=backend.config
terraform fmt && terraform validate

terraform apply -auto-approve

terraform destroy -auto-approve
```

---

## Connect with PGAdmin 4

![pic](./doc/connect_pg.png)

- Connect exec

![pic](./doc/connect_exec.png)