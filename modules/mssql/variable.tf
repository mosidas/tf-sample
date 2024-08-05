variable "sql_server_name" {}
variable "sql_database_name" {}
variable "database_version" {}
variable "sql_database_id" {}
variable "sql_database_admin_password" {
  type      = string
  sensitive = true
}
variable "location" {}
variable "resource_group_name" {}
variable "tags" {}
