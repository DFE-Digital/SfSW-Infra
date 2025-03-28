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

  site_config {}

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY              = azurerm_application_insights.app_insights_web.instrumentation_key
    ASPNETCORE_HTTP_PORTS                       = 80
    CPD_GOOGLEANALYTICSTAG                      = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.google_analytics_tag.versionless_id})"
    CPD_SPACE_ID                                = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.cpd_space_id.versionless_id})"
    CPD_PREVIEW_KEY                             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.cpd_preview_key.versionless_id})"
    CPD_DELIVERY_KEY                            = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.cpd_delivery_key.versionless_id})"
    CPD_TENANTID                                = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.tenant_id.versionless_id})"
    CPD_AZURE_ENVIRONMENT                       = "Dev"
    CPD_CONTENTFUL_ENVIRONMENT                  = "Dev"
    CPD_INSTRUMENTATION_CONNECTIONSTRING        = azurerm_application_insights.app_insights_web.connection_string
    CPD_CLARITY                                 = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.cpd_clarity.versionless_id})"
    CPD_FEATURE_POLLING_INTERVAL                = "300"
    CPD_SEARCH_CLIENT_API_KEY                   = ""
    CPD_SEARCH_ENDPOINT                         = ""
    CPD_SEARCH_INDEX_NAME                       = ""
    CPD_AZURE_DATA_PROTECTION_CONTAINER_NAME    = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.cpd_azure_data_protection_container_name.versionless_id})"
    CPD_AZURE_STORAGE_ACCOUNT                   = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.cpd_azure_storage_account.versionless_id})"
    CPD_AZURE_MANAGED_IDENTITY_ID               = "ai-search?"
    CPD_AZURE_STORAGE_ACCOUNT_URI_FORMAT_STRING = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.cpd_azure_storage_account_uri_format_string.versionless_id})"
    DOCKER_ENABLE_CI                            = "true"
  }
  identity {
    type = "SystemAssigned"
  }
}
