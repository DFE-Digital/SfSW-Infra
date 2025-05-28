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

  frontend_ip_configuration {
    name                 = "appgw-ip"
    public_ip_address_id = data.azurerm_public_ip.appgw_ip.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_port {
    name = "https"
    port = 443
  }

  ssl_certificate {
    name                = "appgw-ssl-cert"
    key_vault_secret_id = data.azurerm_key_vault_certificate.sfsw_cert.secret_id
  }

  backend_address_pool {
    name  = "backendpool"
    fqdns = ["app-sfsw-d01.azurewebsites.net"]
  }

  backend_http_settings {
    name                  = "https-settings"
    port                  = 443
    protocol              = "Https"
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

  http_listener {
    name                           = "https-listener"
    frontend_ip_configuration_name = "appgw-ip"
    frontend_port_name             = "https"
    protocol                       = "Https"
    ssl_certificate_name           = "appgw-ssl-cert"
  }

  redirect_configuration {
    name                    = "http-to-https-redirect"
    redirect_type           = "Permanent"
    target_listener_name    = "https-listener"
    include_path            = true
    include_query_string    = true
  }

  request_routing_rule {
    name                        = "http-redirect-rule"
    rule_type                   = "Basic"
    http_listener_name          = "http-listener"
    redirect_configuration_name = "http-to-https-redirect"
    priority                    = 1
  }

  request_routing_rule {
    name                       = "https-rule"
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = "backendpool"
    backend_http_settings_name = "https-settings"
    priority                   = 2
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.mi_appgw.id]
  }
}
