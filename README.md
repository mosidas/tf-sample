# tf-sample

## install

- terraform
- tfsec
- azure-cli
- vscode
  - hashicorp.terraform

## check

```bash
tfsec .
```

## execute

```bash
cd env/{env}
terraform init
terraform plan --var-file=dev.tfvars
terraform apply --var-file=dev.tfvars
terraform destroy --var-file=dev.tfvars
```
