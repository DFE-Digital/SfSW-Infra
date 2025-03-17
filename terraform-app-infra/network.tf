# resource "azurerm_public_ip" "app_ip" {
#   name                = "pip-${var.project_name}-${var.instance}"
#   location            = azurerm_resource_group.webapp_rg.location
#   resource_group_name = azurerm_resource_group.webapp_rg.name
#   allocation_method   = "Static"
# }

resource "azurerm_virtual_network" "webapp_vnet" {
  name                = "vnet-${var.project_name}-${var.instance}"
  address_space       = ["10.0.0.0/21"]
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
}

resource "azurerm_subnet" "private_endpoints_subnet" {
  name                 = "snet-privateendpoints-${var.project_name}-${var.instance}"
  resource_group_name  = azurerm_resource_group.webapp_rg.name
  virtual_network_name = azurerm_virtual_network.webapp_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
  private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
}

resource "azurerm_subnet" "app_gateway_subnet" {
  name                 = "snet-appgw-${var.project_name}-${var.instance}"
  resource_group_name  = azurerm_resource_group.webapp_rg.name
  virtual_network_name = azurerm_virtual_network.webapp_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
}

resource "azurerm_subnet" "app_service_subnet" {
  name                 = "snet-appservice-${var.project_name}-${var.instance}"
  resource_group_name  = azurerm_resource_group.webapp_rg.name
  virtual_network_name = azurerm_virtual_network.webapp_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
}

# NSG for App Service
resource "azurerm_network_security_group" "app_service_nsg" {
  name                = "nsg-app-service-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name

  security_rule {
    name                       = "block-all-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app_service_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.app_service_subnet.id
  network_security_group_id = azurerm_network_security_group.app_service_nsg.id
}

#-----------------------------------------------------------------------------

# Private endpoints

#-----------------------------------------------------------------------------

# PE, DNS zone and link for App Service:
resource "azurerm_private_endpoint" "app_service_private_endpoint" {
  name                = "pe-app-service-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location  
  subnet_id           = azurerm_subnet.app_service_subnet.id

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
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_service_dns_link" {
  name                  = "app-service-dns-link-${var.project_name}-${var.instance}"
  resource_group_name   = azurerm_resource_group.webapp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.app_service_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.webapp_vnet.id
}




# PE, DNS zone and link for ACR:
resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = "pe-acr-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location  
  subnet_id           = azurerm_subnet.private_endpoints_subnet.id

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
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_dns_link" {
  name                  = "acr-dns-link"
  resource_group_name   = azurerm_resource_group.webapp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.webapp_vnet.id
}




# PE, DNS zone and link for key vault:
resource "azurerm_private_endpoint" "key_vault_private_endpoint" {
  name                = "pe-key-vault-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location  
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
  resource_group_name = azurerm_resource_group.webapp_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_dns_link" {
  name                  = "keyvault-dns-link"
  resource_group_name   = azurerm_resource_group.webapp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.webapp_vnet.id
}




# PE, DNS zone and link for app storage account:
resource "azurerm_private_endpoint" "app_sa_private_endpoint" {
  name                = "pe-app-storage-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location
  subnet_id           = azurerm_subnet.private_endpoints_subnet.id

  private_service_connection {
    name                           = "privatelink-storage-${var.project_name}-${var.instance}"
    private_connection_resource_id = azurerm_storage_account.app_sa.id
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
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_sa_dns_link" {
  name                  = "app-sa-dns-link-${var.project_name}-${var.instance}"
  resource_group_name   = azurerm_resource_group.webapp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.app_sa_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.webapp_vnet.id
}
