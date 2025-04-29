resource "azurerm_public_ip" "appgw_ip" {
  name                = "pip-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.core_infra_rg.location
  resource_group_name = azurerm_resource_group.core_infra_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network" "webapp_vnet" {
  name                = "vnet-${var.project_name}-${var.instance}"
  address_space       = ["${var.webapp_vnet}"]
  location            = azurerm_resource_group.core_infra_rg.location
  resource_group_name = azurerm_resource_group.core_infra_rg.name
}

resource "azurerm_subnet" "private_endpoints_subnet" {
  name                              = "snet-privateendpoints-${var.project_name}-${var.instance}"
  resource_group_name               = azurerm_resource_group.core_infra_rg.name
  virtual_network_name              = azurerm_virtual_network.webapp_vnet.name
  address_prefixes                  = ["${var.private_endpoints_snet}"]
  private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
}

resource "azurerm_subnet" "app_gateway_subnet" {
  name                              = "snet-appgw-${var.project_name}-${var.instance}"
  resource_group_name               = azurerm_resource_group.core_infra_rg.name
  virtual_network_name              = azurerm_virtual_network.webapp_vnet.name
  address_prefixes                  = ["${var.app_gateway_snet}"]
  private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
}

resource "azurerm_subnet" "app_service_subnet" {
  name                              = "snet-appservice-${var.project_name}-${var.instance}"
  resource_group_name               = azurerm_resource_group.core_infra_rg.name
  virtual_network_name              = azurerm_virtual_network.webapp_vnet.name
  address_prefixes                  = ["${var.app_service_snet}"]
  private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
}

resource "azurerm_subnet" "app_service_delegated_subnet" {
  name                              = "snet-appservice-delegated-${var.project_name}-${var.instance}"
  resource_group_name               = azurerm_resource_group.core_infra_rg.name
  virtual_network_name              = azurerm_virtual_network.webapp_vnet.name
  address_prefixes                  = ["${var.app_service_delegated_snet}"]
  private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_subnet" "monitoring_subnet" {
  name                              = "monitoring-subnet"
  resource_group_name               = azurerm_resource_group.core_infra_rg.name
  virtual_network_name              = azurerm_virtual_network.webapp_vnet.name
  address_prefixes                  = ["${var.monitoring_snet}"]
  private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
}




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
