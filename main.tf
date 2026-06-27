terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">= 4.0"

        }
    }

}

provider "azurerm" {
  features {}
  subscription_id = "bfacda6a-6d40-4c26-a322-1afd54edf6b7"
}

# Rung 1: the container that holds everything
resource "azurerm_resource_group" "learning" {
  name     = "learning-terraform"
  location = "UK South"
}

# Rung 2: your first service — object storage (like an S3 bucket)
resource "azurerm_storage_account" "learning" {
  name                     = "stlearnshahbaz01"  # Should be globally unique, so you may need to change this    
  resource_group_name      = azurerm_resource_group.learning.name
  location                 = azurerm_resource_group.learning.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# A "container" inside the storage account = like a folder/bucket inside S3
resource "azurerm_storage_container" "learning" {
    name                  = "learning-container"
    storage_account_id  = azurerm_storage_account.learning.id
    container_access_type = "private"
}

# Output = print a useful value after apply (like AWS "outputs")
output "stage_account_name"{
    value = azurerm_storage_account.learning.name
}