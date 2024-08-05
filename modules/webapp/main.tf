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

  site_config {
    always_on = true
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = var.dotnet_version
    }

  }
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY             = azurerm_application_insights.webapp.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING      = azurerm_application_insights.webapp.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
  }
  tags = var.tags
}

resource "azurerm_application_insights" "webapp" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}
