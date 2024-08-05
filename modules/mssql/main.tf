resource "azurerm_mssql_server" "db" {
  name                          = var.sql_server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.database_version
  administrator_login           = var.sql_database_id
  administrator_login_password  = var.sql_database_admin_password
  public_network_access_enabled = false
  minimum_tls_version           = var.minimum_tls_version
  tags                          = var.tags
}

resource "azurerm_mssql_database" "db" {
  name      = var.sql_database_name
  server_id = azurerm_mssql_server.db.id
}
