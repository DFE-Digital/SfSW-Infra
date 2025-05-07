data "azurerm_key_vault" "key_vault" {
  name                = "kv-${var.project_name}-${var.instance}-temp-2"
  resource_group_name = data.azurerm_resource_group.core_infra_rg.name
}

# Key Vault Secrets User
resource "azurerm_role_assignment" "mi_kv_access" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "4633458b-17de-408a-b874-0445c86b69e6"
  principal_id         = azurerm_user_assigned_identity.mi_app_service.principal_id
}
# Key Vault Certificates Officer
resource "azurerm_role_assignment" "appgw_kv_access" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "a4417e6f-fecd-4de8-b567-7b0420556985"
  principal_id         = azurerm_user_assigned_identity.mi_appgw.principal_id
}

