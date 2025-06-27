resource "azurerm_application_insights_web_test" "availability_test" {
  count                   = var.environment == "Production" ? 1 : 0
  name                    = "at-${var.project_name}-${var.instance}"
  location                = azurerm_application_insights.app_insights_web.location
  resource_group_name     = azurerm_application_insights.app_insights_web.resource_group_name
  application_insights_id = azurerm_application_insights.app_insights_web.id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 60
  enabled                 = true
  retry_enabled           = true
  geo_locations = [
    "emea-fr-pra-edge", # France Central
    "emea-gb-db3-azr",  # North Europe
    "emea-ru-msa-edge", # UK South
    "emea-se-sto-edge", # UK West
    "emea-nl-ams-azr",  # West Europe
  ]

  configuration = base64encode(data.template_file.webtest.rendered)

#   configuration = <<XML
# <WebTest Name="SfSW Availability Test" Id="ABD48585-0831-40CB-9069-682EA6BB3583" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="0" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
#   <Items>
#     <Request Method="GET" Guid="a5f10126-e4cd-570d-961c-cea43999a200" Version="1.1" Url="http://{data.azurerm_public_ip.appgw_ip.ip_address}/application/status" ThinkTime="0" Timeout="300" ParseDependentRequests="True" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
#   </Items>
# </WebTest>
# XML

}

resource "random_uuid" "webtest" {}
resource "random_uuid" "request" {}

data "template_file" "webtest" {
  template = <<EOF
<WebTest Name="${name}" Id="${idGuid}" Enabled="True" Timeout="${timeout}" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010">
  <Items>
    <Request Method="GET" Guid="${requestGuid}" Url="http://${public_ip}/application/status" Timeout="${timeout}" ExpectedHttpStatusCode="${expectedHttpStatusCode}" ParseDependentRequests="False" FollowRedirects="True"/>
  </Items>
</WebTest>
EOF

  vars = {
    name                = "at-${var.project_name}-${var.instance}"
    idGuid              = random_uuid.webtest.result
    requestGuid         = random_uuid.request.result
    timeout             = "60"
    public_ip           = data.azurerm_public_ip.appgw_ip.ip_address
    expectedHttpStatusCode = "200"
  }
}
