variable "subscription_id" {
  description = "The Azure subscription ID"
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

variable "prefix" {
  type        = string
  description = "Prefix for the resource group"
}

variable "project_code" {
  type        = string
  description = "Project code"
}

variable "project_name" {
  type        = string
  description = "Abbreviated project name"
}
