resource "azurerm_application_gateway" "appgw" {
  # count               = var.deploy_appgw
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
    name                = "support-for-social-workers"
    key_vault_secret_id = data.azurerm_key_vault_certificate.sfsw_cert.secret_id
  }

  backend_address_pool {
    name  = "backendpool"
    fqdns = [azurerm_linux_web_app.app_service.default_hostname]
  }

  backend_http_settings {
    name                                = "https-settings"
    port                                = 443
    protocol                            = "Https"
    pick_host_name_from_backend_address = true
    probe_name                          = "https-health-probe"
    cookie_based_affinity               = "Disabled"
    request_timeout                     = 20
  }

  backend_http_settings {
    name                                = "http-settings"
    port                                = 80
    protocol                            = "Http"
    pick_host_name_from_backend_address = true
    probe_name                          = "http-health-probe"
    cookie_based_affinity               = "Disabled"
    request_timeout                     = 20
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
    ssl_certificate_name           = "support-for-social-workers"
  }

  redirect_configuration {
    name                 = "http-to-https-redirect"
    redirect_type        = "Permanent"
    target_listener_name = "https-listener"
    include_path         = true
    include_query_string = true
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

  probe {
    name                                      = "http-health-probe"
    pick_host_name_from_backend_http_settings = true
    path                                      = "/application/status"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    protocol                                  = "Http"
  }

  probe {
    name                                      = "https-health-probe"
    pick_host_name_from_backend_http_settings = true
    path                                      = "/application/status"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    protocol                                  = "Https"
  }

  # custom_error_configuration {
  #   status_code           = "HttpStatus403"
  #   custom_error_page_url = "< custom_error_page_url >"
  # }

  # custom_error_configuration {
  #   status_code           = "HttpStatus502"
  #   custom_error_page_url = "< custom_error_page_url >"
  # }

  rewrite_rule_set {
    name = "rewrite-set"

    rewrite_rule {
      name          = "rewrite-rule"
      rule_sequence = 1

      response_header_configuration {
        header_name  = "X-Frame-Options"
        header_value = "SAMEORIGIN"
      }

      response_header_configuration {
        header_name  = "X-Xss-Protection"
        header_value = "0"
      }

      response_header_configuration {
        header_name  = "X-Content-Type-Options"
        header_value = "nosniff"
      }

      response_header_configuration {
        header_name  = "Content-Security-Policy"
        header_value = "upgrade-insecure-requests; base-uri 'self'; frame-ancestors 'self'; form-action 'self'; object-src 'none';"
      }

      response_header_configuration {
        header_name  = "Referrer-Policy"
        header_value = "strict-origin-when-cross-origin"
      }

      response_header_configuration {
        header_name  = "Strict-Transport-Security"
        header_value = "max-age=31536000; includeSubDomains; preload"
      }

      response_header_configuration {
        header_name  = "Permissions-Policy"
        header_value = "accelerometer=(), ambient-light-sensor=(), autoplay=(), camera=(), encrypted-media=(), fullscreen=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), midi=(), payment=(), picture-in-picture=(), speaker=(), sync-xhr=self, usb=(), vr=()"
      }

      response_header_configuration {
        header_name  = "Server"
        header_value = ""
      }

      response_header_configuration {
        header_name  = "X-Powered-By"
        header_value = ""
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.mi_appgw.id]
  }
}
