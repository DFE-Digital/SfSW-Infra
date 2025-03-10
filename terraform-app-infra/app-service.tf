resource "azurerm_service_plan" "app_service_plan" {
  name                = "asp-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app_service" {
  name                = "app-${var.project_name}-${var.instance}"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_service_plan.app_service_plan.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  public_network_access_enabled = false

  site_config {}
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_vnet_connection" {
  app_service_id = azurerm_linux_web_app.app_service.id
  subnet_id      = azurerm_subnet.app_service_subnet.id
}