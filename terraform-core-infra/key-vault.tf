resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault" "key_vault" {
  # name = "kv-${var.project_name}-${var.instance}-${random_string.suffix.result}"
  name                       = "kv-${var.project_name}-${var.instance}-temp-9"  
  location                      = azurerm_resource_group.core_infra_rg.location
  resource_group_name           = azurerm_resource_group.core_infra_rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  enable_rbac_authorization     = false
  public_network_access_enabled = true
}

# resource "azurerm_key_vault_access_policy" "current_sp" {
#   key_vault_id = azurerm_key_vault.key_vault.id
#   tenant_id = data.azurerm_client_config.current.tenant_id
#   object_id = data.azurerm_client_config.current.object_id
#   secret_permissions = [
#     "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
#   ]
#   certificate_permissions = [
#     "Get", "List", "Delete", "Create", "Import", "Update", "ManageContacts",
#     "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers",
#     "Recover", "Backup", "Restore", "Purge"
#   ]
# }

resource "azurerm_key_vault_access_policy" "access_policy_app_kv" {
  key_vault_id       = azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_user_assigned_identity.mi_app_service.principal_id
  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_access_policy" "access_policy_appgw_kv" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.mi_appgw.principal_id
  certificate_permissions = [
    "Get",
    "List"
  ]
}




#  Key Vault Administrator
# resource "azurerm_role_assignment" "current_sp_kv_admin" {
#   scope                = azurerm_key_vault.key_vault.id
#   role_definition_name = "Key Vault Administrator"
#   principal_id         = data.azurerm_client_config.current.object_id
#   principal_type       = "ServicePrincipal"
# }

resource "azurerm_key_vault_secret" "cpd_space_id" {
  name         = "cpd-space-id"
  value        = "placeholder"
  key_vault_id = azurerm_key_vault.key_vault.id
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "azurerm_key_vault_secret" "cpd_preview_key" {
  name         = "cpd-preview-key"
  value        = "placeholder"
  key_vault_id = azurerm_key_vault.key_vault.id
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "azurerm_key_vault_secret" "cpd_delivery_key" {
  name         = "cpd-delivery-key"
  value        = "placeholder"
  key_vault_id = azurerm_key_vault.key_vault.id
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "azurerm_key_vault_secret" "google_analytics_tag" {
  name         = "google-analytics-tag"
  value        = "placeholder"
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "cpd_clarity" {
  name         = "cpd-clarity"
  value        = "placeholder"
  key_vault_id = azurerm_key_vault.key_vault.id
}


