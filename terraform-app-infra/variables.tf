variable "app_gateway_snet" {
  description = "Subnet address prefix"
  type        = string
}

variable "app_service_snet" {
  description = "Subnet address prefix"
  type        = string
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

variable "monitoring_snet" {
  description = "Subnet address prefix"
  type        = string
}

variable "private_endpoints_snet" {
  description = "Subnet address prefix"
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

variable "webapp_vnet" {
  description = "VNet address range"
  type        = string
}
