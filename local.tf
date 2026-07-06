locals {
  common_tags = {
    environment = var.environment
    managed_by  = "Terraform"
    project     = "Learning"
  }

  # Naming prefix — ensures consistent naming across all resources
  name_prefix = "learning"
}