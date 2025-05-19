data "azurerm_key_vault" "key_vault" {
  name                = "kv-${var.project_name}-${var.instance}-temp-9"
  resource_group_name = data.azurerm_resource_group.core_infra_rg.name
}

data "azurerm_key_vault_certificate" "sfsw_cert" {
  name         = var.ssl_cert_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}










          # ------------------------------------------
            # use for managed identity with RBAC
          # ------------------------------------------

# # Key Vault Secrets User
# resource "azurerm_role_assignment" "mi_kv_access" {
#   scope                = data.azurerm_key_vault.key_vault.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = azurerm_user_assigned_identity.mi_app_service.principal_id
#   principal_type       = "ServicePrincipal"
# }
# # Key Vault Certificates Officer
# resource "azurerm_role_assignment" "appgw_kv_access" {
#   scope                = data.azurerm_key_vault.key_vault.id
#   role_definition_name = "Key Vault Certificates Officer"
#   principal_id         = azurerm_user_assigned_identity.mi_appgw.principal_id
#   principal_type       = "ServicePrincipal"
# }














# resource "azurerm_key_vault_secret" "acr_username_kv" {
#   name         = "acr-username"
#   value        = azurerm_container_registry.acr.admin_username
#   key_vault_id = data.azurerm_key_vault.key_vault.id
# }

# resource "azurerm_key_vault_secret" "acr_password_kv" {
#   name         = "acr-password"
#   value        = azurerm_container_registry.acr.admin_password
#   key_vault_id = data.azurerm_key_vault.key_vault.id
# }
