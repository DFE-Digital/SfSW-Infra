resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault" "key_vault" {
  name = "kv-${var.project_name}-${var.instance}-${random_string.suffix.result}"
  # name                       = "kv-${var.project_name}-${var.instance}"  
  location                   = azurerm_resource_group.shared_rg.location
  resource_group_name        = azurerm_resource_group.shared_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  enable_rbac_authorization  = false
  lifecycle {
    prevent_destroy = false
  }
}

# Access policy for system-assigned MI
resource "azurerm_key_vault_access_policy" "kv_sys_mi" {
  key_vault_id       = azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_linux_web_app.app_service.identity[0].principal_id
  secret_permissions = ["Get"]
}

resource "azurerm_key_vault_secret" "google_analytics_tag" {
  name         = "google-analytics-tag"
  value        = "placeholder"
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "cpd_space_id" {
  name         = "cpd-space-id"
  value        = "placeholder"
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "cpd_preview_key" {
  name         = "cpd-preview-key"
  value        = "placeholder"
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "cpd_delivery_key" {
name         = "cpd-delivery-key"
value        = "placeholder"
key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "tenant_id" {
name         = "tenant-id"
value        = "placeholder"
key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "cpd_clarity" {
name         = "cpd-clarity"
value        = "placeholder"
key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "cpd_azure_data_protection_container_name" {
name         = "cpd-azure-data-protection-container-name"
value        = "placeholder"
key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "cpd_azure_storage_account" {
name         = "cpd-azure-storage-account"
value        = "placeholder"
key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "cpd_azure_storage_account_uri_format_string" {
name         = "cpd-azure-storage-account-uri-format-string"
value        = "placeholder"
key_vault_id = azurerm_key_vault.key_vault.id
}
