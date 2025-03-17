resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault" "key_vault" {
  name                       = "kv-${var.project_name}-${var.instance}-${random_string.suffix.result}"
  location                   = azurerm_resource_group.webapp_rg.location
  resource_group_name        = azurerm_resource_group.webapp_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  enable_rbac_authorization  = true
}