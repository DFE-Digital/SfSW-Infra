# variable "deploy_appgw" {
#   description = "Controls whether the private Application Gateway is deployed. Set to 1 to include, 0 to exclude."
#   type        = number
# }

variable "appgw_sku_name" {
  description = "Application Gateway SKU name"
  type = string
}

variable "appgw_sku_tier" {
  description = "Application Gateway SKU tier"
  type = string
}

variable "cpd_azure_environment" {
  description = "The environment (e.g., dev, prod) for CPD_AZURE_ENVIRONMENT"
  type = string
}

variable "cpd_contentful_environment" {
  description = "The environment (e.g., dev, prod) for CPD_CONTENTFUL_ENVIRONMENT"
  type = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

variable "instance" {
  description = "The instance identifier (e.g., d01, t02)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "project_code" {
  description = "Project code"
  type        = string
}

variable "project_name" {
  description = "Abbreviated project name"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
}

variable "ssl_cert_name" {
  description = "The name of the SLL certificate in Key Vault"
  type        = string
}