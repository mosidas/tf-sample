output "app_service_plan_id" {
  value = azurerm_service_plan.webapp.id
}

output "app_service_id" {
  value = azurerm_windows_web_app.webapp.id
}

output "app_insights_id" {
  value = azurerm_application_insights.webapp.id
}

