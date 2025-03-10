resource "azurerm_storage_account" "app_sa_demo" {
  name                     = "sa${var.project_name}${var.instance}x"
  resource_group_name      = azurerm_resource_group.webapp_rg.name
  location                 = azurerm_resource_group.webapp_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}