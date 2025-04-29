data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "core_infra_rg" {
  name     = "${var.project_code}${var.instance}-rg-${var.project_name}-core-infra"
  location = var.location
  tags = local.tags
}
