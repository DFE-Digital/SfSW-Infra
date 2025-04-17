resource "azurerm_log_analytics_workspace" "log_analytics_ws" {
  name                       = "log-${var.project_name}-${var.instance}"
  location                   = azurerm_resource_group.webapp_rg.location
  resource_group_name        = azurerm_resource_group.webapp_rg.name
  sku                        = "PerGB2018"
  internet_ingestion_enabled = false
  internet_query_enabled     = false
}

# resource "azurerm_application_insights" "app_insights_web" {
#   name                = "ai-${var.project_name}-${var.instance}"
#   location            = azurerm_resource_group.webapp_rg.location
#   resource_group_name = azurerm_resource_group.webapp_rg.name
#   application_type    = "web"
# }

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_law" {
  name                       = "diag-${var.project_name}-${var.instance}"
  target_resource_id         = azurerm_linux_web_app.app_service.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_ws.id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_log {
    category = "AppServiceAppLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
