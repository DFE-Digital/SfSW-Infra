data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "webapp_rg" {
  name     = "${var.project_code}${var.instance}-rg-${var.project_name}-app"
  location = var.location
  tags = local.tags
}

data "azurerm_resource_group" "core_infra_rg" {
  name = "${var.project_code}${var.instance}-rg-${var.project_name}-core-infra"
}

resource "azurerm_resource_group" "private_endpoints_rg" {
  name     = "${var.project_code}${var.instance}-rg-${var.project_name}-private-endpoints"
  location = var.location
  tags     = local.tags
}