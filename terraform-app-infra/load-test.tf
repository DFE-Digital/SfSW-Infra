resource "azurerm_load_test" "load_test" {
  count               = var.environment == "Production" ? 1 : 0
  name                = "lt-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location  
}
