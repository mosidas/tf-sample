# tf-sample

## install

- terraform
- tfsec
- azure-cli
- vscode
  - hashicorp.terraform

## setup

- create service principal
```bash
az login --tenant {tenant_id}
az ad sp create-for-rbac --role Contributor --scopes "/subscriptions/{azure_subscription_id}" --name "{sp_name}"
{
  "appId": "xxx", # copy this
  "displayName": "{sp_name}",
  "password": "xxx", # copy this
  "tenant": "xxx"
}
```
- create `evnv/{env}/{env}.tfvars`
```ini
subscription_id = "{azure_subscription_id}"
tenant_id       = "{azure_tenant_id}"
client_id       = "{sp_appId}"
client_secret   = "{sp_password}"
```

## check

```bash
tfsec .
```

## execute

```bash
cd env/{env}
terraform init
terraform plan --var-file={env}.tfvars
terraform apply --var-file={env}.tfvars
terraform destroy --var-file={env}.tfvars
```
