data "azurerm_user_assigned_identity" "mi_app_service" {
  name                = "uai-app-service-${var.project_name}-${var.instance}"
  resource_group_name = data.azurerm_resource_group.core_infra_rg.name
}

data "azurerm_user_assigned_identity" "mi_appgw" {
  name                = "uai-appgw-${var.project_name}-${var.instance}"
  resource_group_name = data.azurerm_resource_group.core_infra_rg.name
}

resource "azurerm_role_assignment" "mi_app_service_sa_access" {
  scope                = azurerm_storage_account.error_page_sa.resource_manager_id
  principal_type       = "ServicePrincipal"
  principal_id         = data.azurerm_user_assigned_identity.mi_app_service.principal_id
  role_definition_name = "Storage Blob Data Contributor"
}
