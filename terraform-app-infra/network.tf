# Public IP
data "azurerm_public_ip" "appgw_ip" {
  name                = "pip-${var.project_name}-${var.instance}"
  resource_group_name = data.azurerm_resource_group.core_infra_rg.name
}

# Virtual Network
data "azurerm_virtual_network" "webapp_vnet" {
  name                = "vnet-${var.project_name}-${var.instance}"
  resource_group_name = data.azurerm_resource_group.core_infra_rg.name
}

# Subnets
data "azurerm_subnet" "private_endpoints_subnet" {
  name                 = "snet-privateendpoints-${var.project_name}-${var.instance}"
  virtual_network_name = data.azurerm_virtual_network.webapp_vnet.name
  resource_group_name  = data.azurerm_resource_group.core_infra_rg.name
}

data "azurerm_subnet" "app_gateway_subnet" {
  name                 = "snet-appgw-${var.project_name}-${var.instance}"
  virtual_network_name = data.azurerm_virtual_network.webapp_vnet.name
  resource_group_name  = data.azurerm_resource_group.core_infra_rg.name
}

data "azurerm_subnet" "app_service_subnet" {
  name                 = "snet-appservice-${var.project_name}-${var.instance}"
  virtual_network_name = data.azurerm_virtual_network.webapp_vnet.name
  resource_group_name  = data.azurerm_resource_group.core_infra_rg.name
}

data "azurerm_subnet" "app_service_delegated_subnet" {
  name                 = "snet-appservice-delegated-${var.project_name}-${var.instance}"
  virtual_network_name = data.azurerm_virtual_network.webapp_vnet.name
  resource_group_name  = data.azurerm_resource_group.core_infra_rg.name
}

data "azurerm_subnet" "monitoring_subnet" {
  name                 = "monitoring-subnet"
  virtual_network_name = data.azurerm_virtual_network.webapp_vnet.name
  resource_group_name  = data.azurerm_resource_group.core_infra_rg.name
}

#-----------------------------------------------------------------------------
# VNet integration for App Service
#-----------------------------------------------------------------------------

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_vnet_integration" {
  app_service_id = azurerm_linux_web_app.app_service.id
  subnet_id      = data.azurerm_subnet.app_service_delegated_subnet.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_slot_vnet_integration" {
  app_service_id = azurerm_linux_web_app_slot.staging.id
  subnet_id      = data.azurerm_subnet.app_service_delegated_subnet.id
}
