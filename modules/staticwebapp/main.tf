resource "azurerm_static_web_app" "example" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_tier            = var.sku_tier
  tags                = var.tags
}
