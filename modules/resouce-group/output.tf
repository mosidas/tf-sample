output "rg" {
  value = {
    name     = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    tags     = azurerm_resource_group.rg.tags
  }
}
