variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "subnet_id" {}
variable "resource_id" {}
variable "subresource_names" {
  type = list(string)
}

resource "azurerm_private_endpoint" "pe" {
  name                = "pe-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "pe-connection-${var.name}"
    private_connection_resource_id = var.resource_id
    subresource_names              = var.subresource_names
    is_manual_connection           = false
  }
}
