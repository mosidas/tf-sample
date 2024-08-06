resource "azurerm_subnet" "subnet" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes

  # var.delegation_name が空でないときのみdelegationを設定
  dynamic "delegation" {
    for_each = var.delegation_name != "" ? [var.delegation_name] : []
    content {
      name = "delegation-${var.name}"
      service_delegation {
        name = var.service_delegation_name
      }
    }
  }
}
