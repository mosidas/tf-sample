variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}
