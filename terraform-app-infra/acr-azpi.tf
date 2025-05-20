resource "azapi_update_resource" "acr_identity_patch" {
  type      = "Microsoft.Web/sites/config@2022-03-01"
  resource_id = "${azurerm_linux_web_app.app_service.id}/config/web"
  body = {
    properties = {
      acrUseManagedIdentityCreds = true
      acrUserManagedIdentityID   = data.azurerm_user_assigned_identity.mi_app_service.id
    }
  }
}