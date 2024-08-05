output "sql_server_id" {
  value = azurerm_mssql_server.db.id
}

output "sql_database_id" {
  value = azurerm_mssql_database.db.id
}
