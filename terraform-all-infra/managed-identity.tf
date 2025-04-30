resource "azurerm_user_assigned_identity" "mi_appgw" {
  name                = "uai-appgw-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location
}
