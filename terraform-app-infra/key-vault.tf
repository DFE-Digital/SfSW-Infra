data "azurerm_key_vault" "key_vault" {
  name                = "kv-${var.project_name}-${var.instance}-temp-2"
  resource_group_name = data.azurerm_resource_group.core_infra_rg.name
}

resource "azurerm_key_vault_access_policy" "access_policy_app_kv" {
  key_vault_id       = data.azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_linux_web_app.app_service.identity[0].principal_id
  secret_permissions = ["Get"]
}

resource "azurerm_key_vault_access_policy" "access_policy_appgw_kv" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.mi_appgw.principal_id
  secret_permissions      = ["Get"]
  certificate_permissions = ["Get"]
}

resource "azurerm_key_vault_secret" "acr_username_kv" {
  name         = "acr-username"
  value        = azurerm_container_registry.acr.admin_username
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "acr_password_kv" {
  name         = "acr-password"
  value        = azurerm_container_registry.acr.admin_password
  key_vault_id = data.azurerm_key_vault.key_vault.id
}


