resource "azapi_resource" "acr_identity_config" {
  type      = "Microsoft.Web/sites/config@2022-03-01"
  name      = "${azurerm_app_service.app.name}/web"
  parent_id = azurerm_app_service.app.id
  body = {
    properties = {
      acrUseManagedIdentityCreds = true
      acrUserManagedIdentityID   = data.azurerm_user_assigned_identity.mi_app_service.id
    }
  }
}