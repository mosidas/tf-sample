output "app_service_plan_id" {
  value = azurerm_service_plan.example.id
}

output "app_service_id" {
  value = azurerm_linux_web_app.example.id
}

output "app_insights_id" {
  value = azurerm_application_insights.example.id
}
