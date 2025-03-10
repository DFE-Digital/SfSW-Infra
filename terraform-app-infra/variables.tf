variable "resource_group_name" {
  description = "The name of the Azure resource group"
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
  type        = string
  description = "Azure region"
}

variable "project_code" {
  type        = string
  description = "Project code"
}

variable "project_name" {
  type        = string
  description = "Abbreviated project name"
}
