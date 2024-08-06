variable "app_service_id" {}
variable "subnet_id" {}

resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegration" {
  app_service_id = var.app_service_id
  subnet_id      = var.subnet_id
}
