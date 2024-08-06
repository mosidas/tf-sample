resource "azurerm_service_plan" "webapp" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name
}

resource "azurerm_windows_web_app" "webapp" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.webapp.id
  app_settings        = var.app_settings
  site_config {
    always_on = true
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = var.dotnet_version
    }

  }
  tags = var.tags
}
