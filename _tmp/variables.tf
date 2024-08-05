# azure service principal info
variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

# common
variable "location" {}
variable "env" {}
variable "name" {}

# resource
variable "resource_group_name" {}
variable "storage_account_name" {}
variable "storage_container_name" {}
variable "sql_server_name" {}
variable "sql_database_name" {}
variable "sql_database_id" {}
variable "sql_database_admin_password" {
  type      = string
  sensitive = true
}
variable "app_service_plan_name" {}
variable "app_service_name" {}
variable "app_insights_name" {}

