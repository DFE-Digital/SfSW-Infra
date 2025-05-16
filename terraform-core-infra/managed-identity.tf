resource "azurerm_user_assigned_identity" "mi_app_service" {
  name                = "uai-app-service-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.core_infra_rg.location
  resource_group_name = azurerm_resource_group.core_infra_rg.name
}

resource "azurerm_user_assigned_identity" "mi_appgw" {
  name                = "uai-appgw-${var.project_name}-${var.instance}"
  location            = azurerm_resource_group.core_infra_rg.location
  resource_group_name = azurerm_resource_group.core_infra_rg.name
}
