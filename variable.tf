# ============================================
# Core Infrastructure Variables
# ============================================


variable "location" {
  description = "Primary Azure region where resources will be created."
  type        = string
  default     = "westeurope"
}

variable "sql_location" {
  description = "Azure region where SQL resources will be created."
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group."
  type        = string
  default     = "rg-learning-shahbaz"
}

variable "environment" {
  description = "Environment name (e.g., dev, test, prod)."
  type        = string
  default     = "Learning"
}

# ============================================
# Network Variables
# ============================================

variable "vnet_address_space" {
  description = "Address space for the Azure Virtual Network."
  type        = string
  default     = "10.0.0.0/16"
}


variable "subnet_address_prefix" {
  description = "Address prefix for the Azure Subnet."
  type        = string
  default     = "10.0.1.0/24"
}

# ============================================
# VM Variables
# ============================================

variable "vm_size" {
  description = "Size of the Azure Virtual Machine."
  type        = string
  default     = "Standard_B2ts_v2"
}

variable "vm_admin_username" {
  description = "Admin username for the Azure Virtual Machine."
  type        = string
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "Admin password for the Azure Virtual Machine."
  type        = string
  default     = "P@ssw0rd1234"
}

variable "allowed_ssh_ip" {
  description = "IP address allowed to SSH into the VM."
  type        = string
  default     = "24.206.111.172"
}

# ============================================
# App Service Variables
# ============================================

variable "app_service_sku" {
  description = "SKU for the Azure App Service Plan."
  type        = string
  default     = "B1"
}

# ============================================
# SQL Variables
# ============================================

variable "sql_admin_username" {
  description = "Administrator login for Azure SQL Server"
  type        = string
  default     = "sqladmin"
}

variable "sql_database_sku" {
  description = "SKU for Azure SQL Database"
  type        = string
  default     = "Basic"
}


