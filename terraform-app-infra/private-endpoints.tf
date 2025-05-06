
#-----------------------------------------------------------------------------
# Private endpoints
#-----------------------------------------------------------------------------

# PE, DNS zone and link for key vault:
resource "azurerm_private_endpoint" "key_vault_private_endpoint" {
  name                = "pe-key-vault-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.core_infra_rg.name
  location            = azurerm_resource_group.core_infra_rg.location
  subnet_id           = azurerm_subnet.private_endpoints_subnet.id

  private_service_connection {
    name                           = "keyvault-connection"
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "keyvault-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault_private_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone" "key_vault_private_dns_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.core_infra_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_dns_link" {
  name                  = "keyvault-dns-link"
  resource_group_name   = azurerm_resource_group.core_infra_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.webapp_vnet.id
}




# PE, DNS zone and link for App Service:
resource "azurerm_private_endpoint" "app_service_private_endpoint" {
  name                = "pe-app-service-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location
  subnet_id           = data.azurerm_subnet.app_service_subnet.id

  private_service_connection {
    name                           = "privatelink-app-service-${var.project_name}-${var.instance}"
    private_connection_resource_id = azurerm_linux_web_app.app_service.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "app-service-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.app_service_private_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone" "app_service_private_dns_zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  depends_on = [ azurerm_linux_web_app.app_service ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_service_dns_link" {
  name                  = "app-service-dns-link-${var.project_name}-${var.instance}"
  resource_group_name   = azurerm_resource_group.webapp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.app_service_private_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.webapp_vnet.id
}




# PE, DNS zone and link for ACR:
resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = "pe-acr-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location
  subnet_id           = data.azurerm_subnet.private_endpoints_subnet.id

  private_service_connection {
    name                           = "acr-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "acr-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr_private_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone" "acr_private_dns_zone" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  depends_on = [ azurerm_container_registry.acr ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_dns_link" {
  name                  = "acr-dns-link"
  resource_group_name   = azurerm_resource_group.webapp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_private_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.webapp_vnet.id
}







# PE, DNS zone and link for app storage account:
resource "azurerm_private_endpoint" "app_sa_private_endpoint" {
  name                = "pe-app-storage-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location
  subnet_id           = data.azurerm_subnet.private_endpoints_subnet.id

  private_service_connection {
    name                           = "privatelink-storage-${var.project_name}-${var.instance}"
    private_connection_resource_id = azurerm_storage_account.error_page_sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "storage-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.app_sa_private_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone" "app_sa_private_dns_zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  depends_on = [ azurerm_storage_account.error_page_sa ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_sa_dns_link" {
  name                  = "app-sa-dns-link-${var.project_name}-${var.instance}"
  resource_group_name   = azurerm_resource_group.webapp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.app_sa_private_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.webapp_vnet.id
}



# Private Endpoint for AMPLS (shared for both services)
resource "azurerm_private_endpoint" "ampls_pe" {
  name                = "pe-ampls-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  subnet_id           = data.azurerm_subnet.monitoring_subnet.id

  private_service_connection {
    name                           = "ampls-connection"
    private_connection_resource_id = azurerm_monitor_private_link_scope.ampls.id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "monitor-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.monitor_dns.id]
  }
}

resource "azurerm_private_dns_zone" "monitor_dns" {
  name                = "privatelink.monitor.azure.com"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  depends_on = [ azurerm_monitor_private_link_scope.ampls ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "monitor_vnet_link" {
  name                  = "monitor-dns-link-${var.project_name}-${var.instance}"
  resource_group_name   = azurerm_resource_group.webapp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.monitor_dns.name
  virtual_network_id    = data.azurerm_virtual_network.webapp_vnet.id
}

# Azure Monitor Private Link Scope (AMPLS) for both Log Analytics and Application Insights
resource "azurerm_monitor_private_link_scope" "ampls" {
  name                = "ampls-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
}

# Link Log Analytics to AMPLS
resource "azurerm_monitor_private_link_scoped_service" "log_analytics_link" {
  name                = "log-link-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  scope_name          = azurerm_monitor_private_link_scope.ampls.name
  linked_resource_id  = azurerm_log_analytics_workspace.log_analytics_ws.id
}

# Link Application Insights to AMPLS
# resource "azurerm_monitor_private_link_scoped_service" "app_insights_link" {
#   name                = "ai-link-${var.project_name}-${var.instance}"
#   resource_group_name = azurerm_resource_group.webapp_rg.name
#   scope_name          = azurerm_monitor_private_link_scope.ampls.name
#   linked_resource_id  = azurerm_application_insights.app_insights_web.id
# }
