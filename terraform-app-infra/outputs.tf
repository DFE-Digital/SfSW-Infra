output "storage_account_name" {
  value = azurerm_storage_account.error_page_sa.name
}

output "resource_group_name" {
  value = azurerm_storage_account.error_page_sa.resource_group_name
}

output "container_name" {
value = azurerm_storage_container.error_page_container.name
}

output "keyvault_name" {
  value = azurerm_key_vault.key_vault.name
}