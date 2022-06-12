# nuxt-aws-starter

```shell
cd terraform
terraform apply -target=aws_ecr_repository.ecr_repository

cd ../nuxt
sh init_ecr.sh

cd ../terraform
terraform apply
```
