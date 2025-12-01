resource "azurerm_public_ip" "appgw_ip" {
  name                = "pip-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.core_infra_rg.location
  resource_group_name = azurerm_resource_group.core_infra_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_virtual_network" "webapp_vnet" {
  name                = "vnet-${var.project_name}-${var.instance}"
  address_space       = ["${var.webapp_vnet}"]
  location            = azurerm_resource_group.core_infra_rg.location
  resource_group_name = azurerm_resource_group.core_infra_rg.name

  lifecycle {
    ignore_changes = [tags]
  }
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

  delegation {
    name = "appgw_delegation"
    service_delegation {
      name    = "Microsoft.Network/applicationGateways"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
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
