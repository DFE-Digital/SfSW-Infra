resource "azurerm_key_vault" "key_vault" {
  name                          = "kv-${var.project_name}-${var.instance}"
  location                      = azurerm_resource_group.core_infra_rg.location
  resource_group_name           = azurerm_resource_group.core_infra_rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  rbac_authorization_enabled    = false
  public_network_access_enabled = true
  purge_protection_enabled      = true

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_key_vault_access_policy" "current_sp" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]
  certificate_permissions = [
    "Get", "List", "Delete", "Create", "Import", "Update", "ManageContacts",
    "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers",
    "Recover", "Backup", "Restore", "Purge"
  ]
  key_permissions = [
    "Get", "List", "Update", "Create", "Delete", "Decrypt", "Encrypt", "WrapKey",
    "UnwrapKey", "Sign", "Verify", "GetRotationPolicy", "SetRotationPolicy", "Rotate",
    "Recover", "Restore", "Backup", "Release", "Import", "Purge"
  ]
}

resource "azurerm_key_vault_secret" "cpd_space_id" {
  name            = "cpd-space-id"
  value           = "placeholder"
  key_vault_id    = azurerm_key_vault.key_vault.id
  expiration_date = timeadd(timestamp(), "8760h")
  lifecycle {
    ignore_changes = [
      value,
      expiration_date
    ]
  }
  depends_on = [azurerm_key_vault_access_policy.current_sp]
}

resource "azurerm_key_vault_secret" "cpd_preview_key" {
  name            = "cpd-preview-key"
  value           = "placeholder"
  key_vault_id    = azurerm_key_vault.key_vault.id
  expiration_date = timeadd(timestamp(), "8760h")
  lifecycle {
    ignore_changes = [
      value,
      expiration_date
    ]
  }
  depends_on = [azurerm_key_vault_access_policy.current_sp]
}

resource "azurerm_key_vault_secret" "cpd_delivery_key" {
  name            = "cpd-delivery-key"
  value           = "placeholder"
  key_vault_id    = azurerm_key_vault.key_vault.id
  expiration_date = timeadd(timestamp(), "8760h")
  lifecycle {
    ignore_changes = [
      value,
      expiration_date
    ]
  }
  depends_on = [azurerm_key_vault_access_policy.current_sp]
}

resource "azurerm_key_vault_secret" "google_analytics_tag" {
  name            = "google-analytics-tag"
  value           = "placeholder"
  key_vault_id    = azurerm_key_vault.key_vault.id
  expiration_date = timeadd(timestamp(), "8760h")
  lifecycle {
    ignore_changes = [
      value,
      expiration_date
    ]
  }
  depends_on = [azurerm_key_vault_access_policy.current_sp]
}

resource "azurerm_key_vault_secret" "cpd_clarity" {
  name            = "cpd-clarity"
  value           = "placeholder"
  key_vault_id    = azurerm_key_vault.key_vault.id
  expiration_date = timeadd(timestamp(), "8760h")
  lifecycle {
    ignore_changes = [
      value,
      expiration_date
    ]
  }
  depends_on = [azurerm_key_vault_access_policy.current_sp]
}
