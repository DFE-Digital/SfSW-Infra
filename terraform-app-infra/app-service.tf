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

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.app_insights_web.instrumentation_key
  }

  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.mi_app_service.id ]
  }
}


resource "azurerm_user_assigned_identity" "mi_app_service" {
  name = "mi-app-service"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location = azurerm_resource_group.webapp_rg.location
}

# resource "azurerm_role_assignment" "app_service_secrets_user" {
#   scope                = azurerm_key_vault.key_vault.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = azurerm_user_assigned_identity.mi_app_service.id
# }

# resource "azurerm_role_assignment" "app_service_secrets_sys" {
#   scope                = azurerm_key_vault.key_vault.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = azurerm_linux_web_app.app_service.identity[0].principal_id
# }