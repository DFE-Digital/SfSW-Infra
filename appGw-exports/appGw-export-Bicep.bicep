param applicationGateways_s185d01_csc_cpd_app_gateway_name string = 's185d01-csc-cpd-app-gateway'
param virtualNetworks_s185d01_chidrens_social_care_cpd_vn01_externalid string = '/subscriptions/31a2beaa-81c6-47f4-8b88-02f0419dc2a3/resourceGroups/s185d01-childrens-social-care-cpd-rg/providers/Microsoft.Network/virtualNetworks/s185d01-chidrens-social-care-cpd-vn01'
param publicIPAddresses_s185d01AGPublicIPAddress_externalid string = '/subscriptions/31a2beaa-81c6-47f4-8b88-02f0419dc2a3/resourceGroups/s185d01-childrens-social-care-cpd-rg/providers/Microsoft.Network/publicIPAddresses/s185d01AGPublicIPAddress'

resource applicationGateways_s185d01_csc_cpd_app_gateway_name_resource 'Microsoft.Network/applicationGateways@2024-05-01' = {
  name: applicationGateways_s185d01_csc_cpd_app_gateway_name
  location: 'westeurope'
  tags: {
    Environment: 'Dev'
    'Parent Business': 'Children’s Care'
    Portfolio: 'Vulnerable Children and Families'
    Product: 'Social Workforce'
    Service: 'Children and Social care'
    'Service Line': 'Children and Social care'
    'Service Offering': 'Social Workforce'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/31a2beaa-81c6-47f4-8b88-02f0419dc2a3/resourcegroups/s185d01-childrens-social-care-cpd-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/s185-uai-cert-read': {}
    }
  }
  properties: {
    sku: {
      name: 'Basic'
      tier: 'Basic'
      family: 'Generation_1'
      capacity: 2
    }
    gatewayIPConfigurations: [
      {
        name: 's185d01-gateway-ip-configuration'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/gatewayIPConfigurations/s185d01-gateway-ip-configuration'
        properties: {
          subnet: {
            id: '${virtualNetworks_s185d01_chidrens_social_care_cpd_vn01_externalid}/subnets/s185d01-chidrens-social-care-cpd-sn01'
          }
        }
      }
    ]
    sslCertificates: [
      {
        name: 'develop-child-family-social-work-career-23'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/sslCertificates/develop-child-family-social-work-career-23'
        properties: {
          keyVaultSecretId: 'https://s185d-cpd-key-vault.vault.azure.net/secrets/develop-child-family-social-work-career-23'
        }
      }
      {
        name: 'support-for-social-workers'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/sslCertificates/support-for-social-workers'
        properties: {
          keyVaultSecretId: 'https://s185d-cpd-key-vault.vault.azure.net/secrets/support-for-social-workers'
        }
      }
    ]
    trustedRootCertificates: []
    frontendIPConfigurations: [
      {
        name: 's185d01AGIPConfig'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendIPConfigurations/s185d01AGIPConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_s185d01AGPublicIPAddress_externalid
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 's185d01FrontendSSLPort'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendPorts/s185d01FrontendSSLPort'
        properties: {
          port: 443
        }
      }
      {
        name: 's185d01FrontendPort'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendPorts/s185d01FrontendPort'
        properties: {
          port: 80
        }
      }
      {
        name: 'port_8080'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendPorts/port_8080'
        properties: {
          port: 8080
        }
      }
      {
        name: 'port_8443'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendPorts/port_8443'
        properties: {
          port: 8443
        }
      }
      {
        name: 'port_1'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendPorts/port_1'
        properties: {
          port: 1
        }
      }
      {
        name: 'port_2'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendPorts/port_2'
        properties: {
          port: 2
        }
      }
    ]
    backendAddressPools: [
      {
        name: 's185d01-chidrens-social-care-cpd-bep'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/backendAddressPools/s185d01-chidrens-social-care-cpd-bep'
        properties: {
          backendAddresses: [
            {
              fqdn: 's185d01-chidrens-social-care-cpd-app-service.azurewebsites.net'
            }
          ]
        }
      }
      {
        name: 'bep-s185ssw-dev-001'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/backendAddressPools/bep-s185ssw-dev-001'
        properties: {
          backendAddresses: [
            {
              fqdn: 's185d01-chidrens-social-care-cpd-app-service.azurewebsites.net'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 's185d01-chidrens-social-care-cpd-bes-http'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/backendHttpSettingsCollection/s185d01-chidrens-social-care-cpd-bes-http'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          affinityCookieName: 'ApplicationGatewayAffinity'
          requestTimeout: 30
          probe: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/probes/s185d01-chidrens-social-care-cpd-hp'
          }
        }
      }
      {
        name: 'bes-s185ssw-dev-001'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/backendHttpSettingsCollection/bes-s185ssw-dev-001'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          affinityCookieName: 'ApplicationGatewayAffinity'
          path: '/'
          requestTimeout: 30
          probe: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/probes/hp-s185ssw-dev-001'
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'HTTP-listener'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/httpListeners/HTTP-listener'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendIPConfigurations/s185d01AGIPConfig'
          }
          frontendPort: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendPorts/s185d01FrontendPort'
          }
          protocol: 'Http'
          hostNames: []
          requireServerNameIndication: false
          customErrorConfigurations: []
        }
      }
      {
        name: 'listener-s185ssw-dev-001'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/httpListeners/listener-s185ssw-dev-001'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendIPConfigurations/s185d01AGIPConfig'
          }
          frontendPort: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendPorts/s185d01FrontendSSLPort'
          }
          protocol: 'Https'
          sslCertificate: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/sslCertificates/support-for-social-workers'
          }
          hostNames: [
            'dev.support-for-social-workers.education.gov.uk'
            'www.dev.support-for-social-workers.education.gov.uk'
          ]
          requireServerNameIndication: true
          customErrorConfigurations: []
        }
      }
      {
        name: 'redirect-listener'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/httpListeners/redirect-listener'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendIPConfigurations/s185d01AGIPConfig'
          }
          frontendPort: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendPorts/s185d01FrontendSSLPort'
          }
          protocol: 'Https'
          sslCertificate: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/sslCertificates/develop-child-family-social-work-career-23'
          }
          hostNames: [
            'dev.develop-child-family-social-work-career.education.gov.uk'
            'www.dev.develop-child-family-social-work-career.education.gov.uk'
          ]
          requireServerNameIndication: true
          customErrorConfigurations: []
        }
      }
      {
        name: 'dummy-listener'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/httpListeners/dummy-listener'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendIPConfigurations/s185d01AGIPConfig'
          }
          frontendPort: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendPorts/s185d01FrontendSSLPort'
          }
          protocol: 'Https'
          sslCertificate: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/sslCertificates/support-for-social-workers'
          }
          hostNames: []
          requireServerNameIndication: false
          customErrorConfigurations: []
        }
      }
      {
        name: 'dummy-listener-2'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/httpListeners/dummy-listener-2'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendIPConfigurations/s185d01AGIPConfig'
          }
          frontendPort: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/frontendPorts/port_8443'
          }
          protocol: 'Https'
          sslCertificate: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/sslCertificates/support-for-social-workers'
          }
          hostNames: []
          requireServerNameIndication: false
          customErrorConfigurations: []
        }
      }
    ]
    urlPathMaps: [
      {
        name: 'rule-s185ssw-d01'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/urlPathMaps/rule-s185ssw-d01'
        properties: {
          defaultBackendAddressPool: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/backendAddressPools/bep-s185ssw-dev-001'
          }
          defaultBackendHttpSettings: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/backendHttpSettingsCollection/bes-s185ssw-dev-001'
          }
          pathRules: [
            {
              name: 'privacy-notice-target'
              id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/urlPathMaps/rule-s185ssw-d01/pathRules/privacy-notice-target'
              properties: {
                paths: [
                  '/privacy'
                ]
                redirectConfiguration: {
                  id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/rule-s185ssw-d01_privacy-notice-target'
                }
              }
            }
            {
              name: 'pathway-programmes-target'
              id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/urlPathMaps/rule-s185ssw-d01/pathRules/pathway-programmes-target'
              properties: {
                paths: [
                  '/pathway-1'
                  '/pathway-2'
                  '/pathway-3'
                  '/pathway-4'
                ]
                redirectConfiguration: {
                  id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/rule-s185ssw-d01_pathway-programmes-target'
                }
              }
            }
          ]
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'rule-s185ssw-d01'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/requestRoutingRules/rule-s185ssw-d01'
        properties: {
          ruleType: 'PathBasedRouting'
          priority: 10
          httpListener: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/httpListeners/listener-s185ssw-dev-001'
          }
          urlPathMap: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/urlPathMaps/rule-s185ssw-d01'
          }
        }
      }
      {
        name: 'HTTP-rule'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/requestRoutingRules/HTTP-rule'
        properties: {
          ruleType: 'Basic'
          priority: 15
          httpListener: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/httpListeners/HTTP-listener'
          }
          redirectConfiguration: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/HTTP-rule'
          }
        }
      }
      {
        name: 'redirect-rule-d01'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/requestRoutingRules/redirect-rule-d01'
        properties: {
          ruleType: 'Basic'
          priority: 20
          httpListener: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/httpListeners/redirect-listener'
          }
          redirectConfiguration: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/redirect-rule-d01'
          }
        }
      }
    ]
    probes: [
      {
        name: 's185d01-chidrens-social-care-cpd-hp'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/probes/s185d01-chidrens-social-care-cpd-hp'
        properties: {
          protocol: 'Http'
          path: '/application/status'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: true
          minServers: 0
          match: {
            statusCodes: [
              '200-399'
            ]
          }
        }
      }
      {
        name: 'hp-s185ssw-dev-001'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/probes/hp-s185ssw-dev-001'
        properties: {
          protocol: 'Https'
          path: '/application/status'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: true
          minServers: 0
          match: {
            statusCodes: [
              '200-399'
            ]
          }
        }
      }
    ]
    rewriteRuleSets: [
      {
        name: 's185d01-csc-cpd-app-gw-rewrite-rule-set'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/rewriteRuleSets/s185d01-csc-cpd-app-gw-rewrite-rule-set'
        properties: {
          rewriteRules: [
            {
              ruleSequence: 1
              conditions: []
              name: 's185d01-csc-cpd-app-gw-rewrite-rule'
              actionSet: {
                requestHeaderConfigurations: []
                responseHeaderConfigurations: [
                  {
                    headerName: 'X-Frame-Options'
                    headerValue: 'SAMEORIGIN'
                  }
                  {
                    headerName: 'X-Xss-Protection'
                    headerValue: '0'
                  }
                  {
                    headerName: 'X-Content-Type-Options'
                    headerValue: 'nosniff'
                  }
                  {
                    headerName: 'Content-Security-Policy'
                    headerValue: 'upgrade-insecure-requests; base-uri \'self\'; frame-ancestors \'self\'; form-action \'self\'; object-src \'none\';'
                  }
                  {
                    headerName: 'Referrer-Policy'
                    headerValue: 'strict-origin-when-cross-origin'
                  }
                  {
                    headerName: 'Strict-Transport-Security'
                    headerValue: 'max-age=31536000; includeSubDomains; preload'
                  }
                  {
                    headerName: 'Permissions-Policy'
                    headerValue: 'accelerometer=(), ambient-light-sensor=(), autoplay=(), camera=(), encrypted-media=(), fullscreen=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), midi=(), payment=(), picture-in-picture=(), speaker=(), sync-xhr=self, usb=(), vr=()'
                  }
                  {
                    headerName: 'Server'
                  }
                  {
                    headerName: 'X-Powered-By'
                  }
                ]
              }
            }
          ]
        }
      }
    ]
    redirectConfigurations: [
      {
        name: 's185d01-cpd-app-gw-rewrite-pathmap'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/s185d01-cpd-app-gw-rewrite-pathmap'
        properties: {
          redirectType: 'Permanent'
          targetListener: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/httpListeners/listener-s185ssw-dev-001'
          }
          includePath: true
          includeQueryString: true
        }
      }
      {
        name: 's185d01-chidrens-social-care-grafana-rule'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/s185d01-chidrens-social-care-grafana-rule'
        properties: {
          redirectType: 'Permanent'
          targetListener: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/httpListeners/listener-s185ssw-dev-001'
          }
          includePath: false
          includeQueryString: false
        }
      }
      {
        name: 'Privacy-notice-rule'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/Privacy-notice-rule'
        properties: {
          redirectType: 'Permanent'
          targetUrl: 'https://www.gov.uk/government/publications/privacy-information-business-contacts-and-stakeholders/privacy-information-business-contacts-and-stakeholders#using-your-data-to-carry-out-research'
          includePath: true
          includeQueryString: false
        }
      }
      {
        name: 'Privacy-notice-rulecdac8a4e-df51-43b1-857e-3db7fbbc00f9'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/Privacy-notice-rulecdac8a4e-df51-43b1-857e-3db7fbbc00f9'
        properties: {
          redirectType: 'Permanent'
          targetUrl: 'https://www.gov.uk/government/publications/privacy-information-business-contacts-and-stakeholders/privacy-information-business-contacts-and-stakeholders#using-your-data-to-carry-out-research'
          includePath: true
          includeQueryString: true
        }
      }
      {
        name: 'Privacy-notice-rule321c3da2-18fe-4196-a2a9-7f32485cd8db'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/Privacy-notice-rule321c3da2-18fe-4196-a2a9-7f32485cd8db'
        properties: {
          redirectType: 'Permanent'
          targetUrl: 'https://gov.uk/government/publications/privacy-information-business-contacts-and-stakeholders/privacy-information-business-contacts-and-stakeholders#using-your-data-to-carry-out-research'
          includePath: true
          includeQueryString: false
        }
      }
      {
        name: 'Privacy-notice-rule035b45c8-be3a-4bb7-aeb2-7ec9f8fb6ca0'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/Privacy-notice-rule035b45c8-be3a-4bb7-aeb2-7ec9f8fb6ca0'
        properties: {
          redirectType: 'Permanent'
          targetUrl: 'https://gov.uk/government/publications/privacy-information-business-contacts-and-stakeholders/privacy-information-business-contacts-and-stakeholders#using-your-data-to-carry-out-research'
          includePath: true
          includeQueryString: false
        }
      }
      {
        name: 'HTTP-rule'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/HTTP-rule'
        properties: {
          redirectType: 'Permanent'
          targetListener: {
            id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/httpListeners/listener-s185ssw-dev-001'
          }
          includePath: true
          includeQueryString: true
          requestRoutingRules: [
            {
              id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/requestRoutingRules/HTTP-rule'
            }
          ]
        }
      }
      {
        name: 'redirect-rule-d01'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/redirect-rule-d01'
        properties: {
          redirectType: 'Permanent'
          targetUrl: 'https://dev.support-for-social-workers.education.gov.uk'
          includePath: true
          includeQueryString: true
          requestRoutingRules: [
            {
              id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/requestRoutingRules/redirect-rule-d01'
            }
          ]
        }
      }
      {
        name: 'rule-s185ssw-d01_privacy-notice-target'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/rule-s185ssw-d01_privacy-notice-target'
        properties: {
          redirectType: 'Permanent'
          targetUrl: 'https://www.gov.uk/government/publications/privacy-information-business-contacts-and-stakeholders/privacy-information-business-contacts-and-stakeholders#using-your-data-to-carry-out-research'
          includePath: false
          includeQueryString: false
          pathRules: [
            {
              id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/urlPathMaps/rule-s185ssw-d01/pathRules/privacy-notice-target'
            }
          ]
        }
      }
      {
        name: 'rule-s185ssw-d01_pathway-programmes-target'
        id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/redirectConfigurations/rule-s185ssw-d01_pathway-programmes-target'
        properties: {
          redirectType: 'Permanent'
          targetUrl: 'https://dev.support-for-social-workers.education.gov.uk/development-programmes'
          includePath: false
          includeQueryString: false
          pathRules: [
            {
              id: '${applicationGateways_s185d01_csc_cpd_app_gateway_name_resource.id}/urlPathMaps/rule-s185ssw-d01/pathRules/pathway-programmes-target'
            }
          ]
        }
      }
    ]
    sslPolicy: {
      policyType: 'Predefined'
      policyName: 'AppGwSslPolicy20170401S'
    }
    enableHttp2: false
    customErrorConfigurations: [
      {
        statusCode: 'HttpStatus403'
        customErrorPageUrl: 'https://s185errorpage.blob.core.windows.net/s185errorpage/403.html'
      }
      {
        statusCode: 'HttpStatus502'
        customErrorPageUrl: 'https://s185errorpage.blob.core.windows.net/s185errorpage/502.html'
      }
    ]
  }
}
