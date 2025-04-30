data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "webapp_rg" {
  name     = "${var.project_code}${var.instance}-rg-${var.project_name}-app"
  location = var.location
  tags = local.tags
}

data "azurerm_resource_group" "core_infra_rg" {
  name = "${var.project_code}${var.instance}-rg-${var.project_name}-core-infra"
}

data "azurerm_key_vault" "key_vault" {
  name                = "kv-${var.project_name}-${var.instance}-temp"
  resource_group_name = data.azurerm_resource_group.core_infra_rg.name
}
