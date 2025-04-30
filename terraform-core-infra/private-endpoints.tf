# PE, DNS zone and link for key vault:
resource "azurerm_private_endpoint" "key_vault_private_endpoint" {
  name                = "pe-key-vault-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.core_infra_rg.name
  location            = azurerm_resource_group.core_infra_rg.location
  subnet_id           = azurerm_subnet.private_endpoints_subnet.id

  private_service_connection {
    name                           = "keyvault-connection"
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "keyvault-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault_private_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone" "key_vault_private_dns_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.core_infra_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_dns_link" {
  name                  = "keyvault-dns-link"
  resource_group_name   = azurerm_resource_group.core_infra_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.webapp_vnet.id
}
