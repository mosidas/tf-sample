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

resource "azurerm_subnet" "subnet" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes

  # var.delegation_name が空でないときのみdelegationを設定
  dynamic "delegation" {
    for_each = var.delegation_name != "" ? [var.delegation_name] : []
    content {
      name = service_delegation.value
      service_delegation {
        name    = var.service_delegation_name
        actions = var.service_delegation_actions
      }
    }
  }
}

output "name" {
  value = azurerm_subnet.subnet.name
}
