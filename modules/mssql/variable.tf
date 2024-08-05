variable "sql_server_name" {}
variable "sql_database_name" {}
variable "database_version" {}
variable "sql_database_id" {}
variable "sql_database_admin_password" {
  type      = string
  sensitive = true
}
variable "public_network_access_enabled" {}
variable "minimum_tls_version" {}
variable "location" {}
variable "resource_group_name" {}
variable "tags" {}
