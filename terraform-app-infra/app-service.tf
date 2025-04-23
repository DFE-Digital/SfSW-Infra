resource "azurerm_service_plan" "app_service_plan" {
  name                = "asp-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app_service" {
  name                = "app-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_service_plan.app_service_plan.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  public_network_access_enabled = false

  site_config {
    application_stack {
      docker_registry_url      = "https://${azurerm_container_registry.acr.login_server}"
      docker_registry_username = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=acr-username)"
      docker_registry_password = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=acr-password)"
      docker_image_name        = "sfsw-app-d01:latest"
    }
    vnet_route_all_enabled = true
  }

  app_settings = {
    #APPINSIGHTS_INSTRUMENTATIONKEY              = azurerm_application_insights.app_insights_web.instrumentation_key
    ASPNETCORE_HTTP_PORTS                       = 80
    CPD_GOOGLEANALYTICSTAG                      = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=google-analytics-tag)"
    CPD_SPACE_ID                                = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=cpd-space-id)"
    CPD_PREVIEW_KEY                             = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=cpd-preview-key)"
    CPD_DELIVERY_KEY                            = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=cpd-delivery-key)"
    CPD_TENANTID                                = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=tenant-id)"
    CPD_AZURE_ENVIRONMENT                       = "dev"
    CPD_CONTENTFUL_ENVIRONMENT                  = "dev"
    #CPD_INSTRUMENTATION_CONNECTIONSTRING        = azurerm_application_insights.app_insights_web.connection_string
    CPD_CLARITY                                 = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=cpd-clarity)"
    CPD_FEATURE_POLLING_INTERVAL                = "300"
    CPD_SEARCH_CLIENT_API_KEY                   = ""
    CPD_SEARCH_ENDPOINT                         = ""
    CPD_SEARCH_INDEX_NAME                       = ""
    CPD_AZURE_DATA_PROTECTION_CONTAINER_NAME    = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=cpd-azure-data-protection-container-name)"
    CPD_AZURE_STORAGE_ACCOUNT                   = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=cpd-azure-storage-account)"
    CPD_AZURE_MANAGED_IDENTITY_ID               = "ai-search?"
    CPD_AZURE_STORAGE_ACCOUNT_URI_FORMAT_STRING = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=cpd-azure-storage-account-uri-format-string)"
    DOCKER_ENABLE_CI                            = "true"
  }
  identity {
    type = "SystemAssigned"
  }
}
