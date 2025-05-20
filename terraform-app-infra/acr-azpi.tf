resource "azapi_resource" "acr_identity_config" {
  type      = "Microsoft.Web/sites/config@2022-03-01"
  name      = "${azurerm_linux_web_app.app_service.name}/web"
  parent_id = azurerm_linux_web_app.app_service.id
  body = jsonencode({
    properties = {
      acrUseManagedIdentityCreds = true
      acrUserManagedIdentityID   = data.azurerm_user_assigned_identity.mi_app_service.id
    }
  })
}