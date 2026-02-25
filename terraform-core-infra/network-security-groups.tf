# NSG for Application Gateway
resource "azurerm_network_security_group" "app_gateway_nsg" {
  name                = "nsg-app-gateway-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.core_infra_rg.location
  resource_group_name = azurerm_resource_group.core_infra_rg.name

  # conditional rule for production only
  dynamic "security_rule" {
    for_each = var.environment == "Production" ? [1] : []
    content {
      name                       = "HTTP-HTTPS"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["80", "443"]
      source_address_prefix      = "Internet"
      destination_address_prefix = var.app_gateway_snet
    }
  }

  security_rule {
    name                       = "Gateway-Manager"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["65200-65535"]
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet_network_security_group_association" "app_gateway_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.app_gateway_subnet.id
  network_security_group_id = azurerm_network_security_group.app_gateway_nsg.id
}

# NSG for App Service
resource "azurerm_network_security_group" "app_service_nsg" {
  name                = "nsg-app-service-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.core_infra_rg.location
  resource_group_name = azurerm_resource_group.core_infra_rg.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet_network_security_group_association" "app_service_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.app_service_subnet.id
  network_security_group_id = azurerm_network_security_group.app_service_nsg.id
}

# NSG for App Service delegated subnet
resource "azurerm_network_security_group" "app_service_delegated_nsg" {
  name                = "nsg-app-service-delegated-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.core_infra_rg.location
  resource_group_name = azurerm_resource_group.core_infra_rg.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet_network_security_group_association" "app_service_delegated_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.app_service_delegated_subnet.id
  network_security_group_id = azurerm_network_security_group.app_service_delegated_nsg.id
}

# NSG for Private Endpoints
resource "azurerm_network_security_group" "private_endpoints_nsg" {
  name                = "nsg-private-endpoints-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.core_infra_rg.location
  resource_group_name = azurerm_resource_group.core_infra_rg.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet_network_security_group_association" "private_endpoints_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.private_endpoints_subnet.id
  network_security_group_id = azurerm_network_security_group.private_endpoints_nsg.id
}

# NSG for monitoring
resource "azurerm_network_security_group" "monitoring_nsg" {
  name                = "nsg-monitoring-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.core_infra_rg.location
  resource_group_name = azurerm_resource_group.core_infra_rg.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet_network_security_group_association" "monitoring_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.monitoring_subnet.id
  network_security_group_id = azurerm_network_security_group.monitoring_nsg.id
}
