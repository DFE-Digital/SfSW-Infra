resource "azurerm_log_analytics_workspace" "log_analytics_ws" {
  name                       = "log-${var.project_name}-${var.instance}"
  location                   = azurerm_resource_group.webapp_rg.location
  resource_group_name        = azurerm_resource_group.webapp_rg.name
  sku                        = "PerGB2018"
  internet_ingestion_enabled = true
  internet_query_enabled     = true
  retention_in_days = 30
}

resource "azurerm_application_insights" "app_insights_web" {
  name                = "ai-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_ws.id
  application_type    = "web"
  disable_ip_masking = true
  internet_ingestion_enabled = true
  internet_query_enabled = true
}

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

resource "azurerm_monitor_diagnostic_setting" "appgw_diagnostics" {
  name               = "appgw-diag"
  target_resource_id = azurerm_application_gateway.appgw.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_ws.id
  
  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }
  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }
  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }
  metric {
    category = "AllMetrics"
  }
}
