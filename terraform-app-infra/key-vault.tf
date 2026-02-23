data "azurerm_key_vault" "key_vault" {
  name                = "kv-${var.project_name}-${var.instance}"
  resource_group_name = data.azurerm_resource_group.core_infra_rg.name
}

data "azurerm_key_vault_certificate" "sfsw_cert" {
  name         = var.ssl_cert_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}


resource "azurerm_key_vault_access_policy" "access_policy_app_kv" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_user_assigned_identity.mi_app_service.principal_id
  secret_permissions = [
    "Get",
    "List"
  ]
  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
}

resource "azurerm_key_vault_access_policy" "access_policy_appgw_kv" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_user_assigned_identity.mi_appgw.principal_id
  certificate_permissions = [
    "Get",
    "List"
  ]
  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_key" "data_protection_key" {
  name            = "data-protection"
  key_vault_id    = data.azurerm_key_vault.key_vault.id
  key_type        = "RSA"
  key_size        = 2048
  expiration_date = timeadd(timestamp(), "8760h")

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}
