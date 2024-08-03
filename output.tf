output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "storage_account_id" {
  value = azurerm_storage_account.example.id
}

output "sql_server_id" {
  value = azurerm_mssql_server.example.id
}

output "app_service_plan_id" {
  value = azurerm_service_plan.example.id
}

output "app_service_id" {
  value = azurerm_linux_web_app.example.id
}

output "app_insights_id" {
  value = azurerm_application_insights.example.id
}
