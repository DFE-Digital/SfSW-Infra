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
  delegation {
    name = "app-service-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }  
}

resource "azurerm_private_dns_zone" "app_service_private_dns_zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.webapp_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_service_network_link" {
  name                  = "app-service-link-${var.project_name}-${var.instance}"
  resource_group_name   = azurerm_resource_group.webapp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.app_service_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.webapp_vnet.id
}

resource "azurerm_private_endpoint" "app_service_private_endpoint" {
  name                = "pe-app-service-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location  
  subnet_id           = azurerm_subnet.private_endpoints_subnet.id

  private_service_connection {
    name                           = "privatelink-app-service-${var.project_name}-${var.instance}"
    private_connection_resource_id = azurerm_linux_web_app.app_service.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}

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