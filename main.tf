resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_mssql_server" "example" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = var.sql_database_id
  administrator_login_password = var.sql_database_admin_password
}

resource "azurerm_mssql_database" "example" {
  name      = var.sql_database_name
  server_id = azurerm_mssql_server.example.id
}

resource "azurerm_service_plan" "example" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Windows"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "example" {
  name                = var.app_service_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    always_on = false
  }
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY             = azurerm_application_insights.example.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING      = azurerm_application_insights.example.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
  }
}

resource "azurerm_application_insights" "example" {
  name                = var.app_insights_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}
