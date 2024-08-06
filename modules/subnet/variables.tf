variable "name" {}
variable "vnet_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "address_prefixes" {
  type    = list(string)
  default = ["10.0.0.0/24"]
}
variable "delegation_name" {}
variable "service_delegation_name" {}
variable "service_delegation_actions" {
  type    = list(string)
  default = ["Microsoft.Web/serverFarms"]
}
