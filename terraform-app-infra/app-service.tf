resource "azurerm_service_plan" "app_service_plan" {
  name                = "asp-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location
  os_type             = "Linux"
  sku_name            = var.appservice_sku_name
}

resource "azurerm_linux_web_app" "app_service" {
  name                = "app-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_service_plan.app_service_plan.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  public_network_access_enabled   = false
  key_vault_reference_identity_id = data.azurerm_user_assigned_identity.mi_app_service.id

  site_config {
    application_stack {
      docker_registry_url = "https://ghcr.io/dfe-digital/support-for-social-workers"
      docker_image_name   = "latest"
    }
    vnet_route_all_enabled                        = true
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = data.azurerm_user_assigned_identity.mi_app_service.client_id
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY       = azurerm_application_insights.app_insights_web.instrumentation_key
    ASPNETCORE_HTTP_PORTS                = 80
    CPD_GOOGLEANALYTICSTAG               = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=google-analytics-tag)"
    CPD_SPACE_ID                         = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=cpd-space-id)"
    CPD_PREVIEW_KEY                      = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=cpd-preview-key)"
    CPD_DELIVERY_KEY                     = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=cpd-delivery-key)"
    CPD_AZURE_ENVIRONMENT                = var.cpd_azure_environment
    CPD_CONTENTFUL_ENVIRONMENT           = var.cpd_contentful_environment
    CPD_INSTRUMENTATION_CONNECTIONSTRING = azurerm_application_insights.app_insights_web.connection_string
    CPD_CLARITY                          = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=cpd-clarity)"
    CPD_FEATURE_POLLING_INTERVAL         = "300"
    CPD_SEARCH_CLIENT_API_KEY            = ""
    CPD_SEARCH_ENDPOINT                  = ""
    CPD_SEARCH_INDEX_NAME                = ""
    DOCKER_ENABLE_CI                     = "false"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE  = "false"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.mi_app_service.id]
  }

  logs {
    application_logs {
      file_system_level = "Verbose"
    }
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
    failed_request_tracing  = true
    detailed_error_messages = true
  }
  depends_on = [azurerm_application_insights.app_insights_web]
}

resource "azurerm_linux_web_app_slot" "staging" {
  count          = var.deploy_app_slot
  name           = "staging"
  app_service_id = azurerm_linux_web_app.app_service.id

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY       = azurerm_application_insights.app_insights_web.instrumentation_key
    ASPNETCORE_HTTP_PORTS                = 80
    CPD_GOOGLEANALYTICSTAG               = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=google-analytics-tag)"
    CPD_SPACE_ID                         = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=cpd-space-id)"
    CPD_PREVIEW_KEY                      = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=cpd-preview-key)"
    CPD_DELIVERY_KEY                     = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=cpd-delivery-key)"
    CPD_AZURE_ENVIRONMENT                = var.cpd_azure_environment
    CPD_CONTENTFUL_ENVIRONMENT           = var.cpd_contentful_environment
    CPD_INSTRUMENTATION_CONNECTIONSTRING = azurerm_application_insights.app_insights_web.connection_string
    CPD_CLARITY                          = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.key_vault.name};SecretName=cpd-clarity)"
    CPD_FEATURE_POLLING_INTERVAL         = "300"
    CPD_SEARCH_CLIENT_API_KEY            = ""
    CPD_SEARCH_ENDPOINT                  = ""
    CPD_SEARCH_INDEX_NAME                = ""
    DOCKER_ENABLE_CI                     = "false"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE  = "false"
  }

  site_config {
    application_stack {
      docker_registry_url = "https://ghcr.io/dfe-digital/support-for-social-workers"
      docker_image_name   = "latest"
    }
    vnet_route_all_enabled                        = true
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = data.azurerm_user_assigned_identity.mi_app_service.client_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.mi_app_service.id]
  }

  logs {
    application_logs {
      file_system_level = "Verbose"
    }
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
    failed_request_tracing  = true
    detailed_error_messages = true
  }
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  count = var.environment == "Production" ? 1 : 0  
  name                = "autoscale-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location
  target_resource_id  = azurerm_service_plan.app_service_plan.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 3
      minimum = 3
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.app_service_plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.app_service_plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 20
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}