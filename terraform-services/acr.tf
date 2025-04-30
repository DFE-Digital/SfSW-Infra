resource "azurerm_container_registry" "acr" {
  name                = "acr${var.project_name}${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location
  sku                 = "Premium"
  admin_enabled       = true
  public_network_access_enabled = false
  lifecycle {
    ignore_changes = [
      network_rule_set[0].ip_rule,
      public_network_access_enabled
    ]
  }
}
