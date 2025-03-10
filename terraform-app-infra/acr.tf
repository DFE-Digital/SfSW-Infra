resource "azurerm_container_registry" "acr" {
  name                = "acr${var.project_name}${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location
  sku                 = "Basic"
  admin_enabled       = false
}
