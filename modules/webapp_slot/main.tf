resource "azurerm_windows_web_app_slot" "webapp" {
  app_service_id = var.app_service_id
  name           = var.slot_name
  app_settings   = var.app_settings

  connection_string {
    name  = var.connection_string_name
    type  = var.connection_string_type
    value = var.connection_string_value
  }

  site_config {
    always_on = true
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = var.dotnet_version
    }
  }

  tags = var.tags
}
