resource "azurerm_application_gateway" "private_appgw" {
  count               = 0
  name                = "private-appgw"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.app_gateway_subnet.id
  }

  frontend_ip_configuration {
    name                          = "private-frontend-ip"
    subnet_id                     = azurerm_subnet.app_gateway_subnet.id
    private_ip_address            = "10.0.1.10"
    private_ip_address_allocation = "Static"
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  backend_address_pool {
    name  = "backend-pool"
    ip_addresses = ["10.0.1.4"]
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "private-frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "http-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 100
  }
}