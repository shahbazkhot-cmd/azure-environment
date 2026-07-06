# ============================================
# Core Infrastructure Variables
# ============================================


variable "location" {
  description = "Primary Azure region where resources will be created."
  type       = string
  default = "westeurope"
}

variable "sql_location" {
  description = "Azure region where SQL resources will be created."
  type       = string
  default = "westeurope"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group."
  type       = string
  default    = "rg-learning-shahbaz"
}

variable "environment" {
  description = "Environment name (e.g., dev, test, prod)."
  type       = string
  default    = "Learning"
}

# ============================================
# Network Variables
# ============================================

variable "vnet_address_space" {
  description = "Address space for the Azure Virtual Network."
  type       = string
  default    = "10.0.0.0/16"
}