resource "azurerm_application_gateway" "appgw" {
  count               = var.deploy_appgw
  name                = "appgw-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "appgw-ipconfig"
    subnet_id = data.azurerm_subnet.app_gateway_subnet.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appgw-ip"
    public_ip_address_id = data.azurerm_public_ip.appgw_ip.id
  }

  backend_address_pool {
    name  = "backendpool"
    fqdns = ["app-sfsw-d01.azurewebsites.net"]
  }

  backend_http_settings {
    name                  = "http-settings"
    port                  = 80
    protocol              = "Http"
    host_name             = "app-sfsw-d01.azurewebsites.net"
    cookie_based_affinity = "Disabled"
    request_timeout       = 20
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "appgw-ip"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "http-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "backendpool"
    backend_http_settings_name = "http-settings"
    priority                   = 1
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi_appgw.id]
  }
}
