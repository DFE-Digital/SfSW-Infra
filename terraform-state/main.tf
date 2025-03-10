resource "azurerm_resource_group" "tfstate_rg" {
  name     = "${var.project_code}${var.instance}-rg-${var.project_name}-tfstate"
  location = var.location
  tags = local.tags
}
