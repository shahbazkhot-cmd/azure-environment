terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
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
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Rung 2: your first service — object storage (like an S3 bucket)
resource "azurerm_storage_account" "learning" {
  name                     = "stlearnshahbaz01" # Should be globally unique, so you may need to change this    
  resource_group_name      = azurerm_resource_group.learning.name
  location                 = azurerm_resource_group.learning.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# A "container" inside the storage account = like a folder/bucket inside S3
resource "azurerm_storage_container" "learning" {
  name                  = "learning-container"
  storage_account_id    = azurerm_storage_account.learning.id
  container_access_type = "private"
}



# Azure Virtual Network (VNet) - the network that holds your servers
resource "azurerm_virtual_network" "main" {
  name                = "${local.name_prefix}-vnet"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name
  address_space       = [var.vnet_address_space]
  tags                = local.common_tags
}

# Azure Subnet - a smaller network inside the VNet
resource "azurerm_subnet" "main" {
  name                 = "${local.name_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.learning.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_address_prefix]
}

# Azure Network Security Group (NSG) - controls traffic to/from the subnet
resource "azurerm_network_security_group" "main" {
  name                = "${local.name_prefix}-nsg"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name
  tags                = local.common_tags
}

# Azure network group rule - allows SSH traffic to the subnet
resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.allowed_ssh_ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.learning.name
  network_security_group_name = azurerm_network_security_group.main.name
}


# Associate the NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Azure Public IP - a public IP address for the VM
resource "azurerm_public_ip" "main" {
  name                = "${local.name_prefix}-public-ip"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name
  allocation_method   = "Static"

  tags = local.common_tags
}
# Azure Network Interface (NIC) - connects the VM to the subnet and public IP
# resource "azurerm_network_interface" "main" {
#   name                = "${local.name_prefix}-nic"
#   location            = azurerm_resource_group.learning.location
#   resource_group_name = azurerm_resource_group.learning.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.main.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.main.id
#   }

#   tags = local.common_tags
# }

# Linux Virtual Machine - the actual server that will run your code
# resource "azurerm_linux_virtual_machine" "main" {
#   name                  = "${local.name_prefix}-vm"
#   resource_group_name   = azurerm_resource_group.learning.name
#   location              = azurerm_resource_group.learning.location
#   size                  = "Standard_B2ts_v2"
#   admin_username        = "azureuser"
#   network_interface_ids = [azurerm_network_interface.main.id]

#   admin_ssh_key {
#     username   = "azureuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "ubuntu-24_04-lts"
#     sku       = "server"
#     version   = "latest"
#   }

#   tags = local.common_tags
# }

# App Service Plan - the "server" that runs your web app
resource "azurerm_service_plan" "main" {
  name                = "${local.name_prefix}-asp"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Web App - the actual web application that will run your code
resource "azurerm_linux_web_app" "main" {
  name                = "${local.name_prefix}-webapp"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on = false
    application_stack {
      python_version = "3.11"
    }
  }

  tags = local.common_tags
}


resource "random_password" "sql" {
  length           = 16
  special          = true
  override_special = "!#$%"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
}

resource "azurerm_mssql_server" "main" {
  name                         = "sqlserver-learning-shahbaz1"
  resource_group_name          = azurerm_resource_group.learning.name
  location                     = var.sql_location # ← was var.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = random_password.sql.result

  tags = local.common_tags
}

resource "azurerm_mssql_database" "main" {
  name        = "${local.name_prefix}-sqldb"
  server_id   = azurerm_mssql_server.main.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  sku_name    = "Basic" # ← back to Basic, now that subscription is upgraded
  max_size_gb = 2

  tags = local.common_tags
}

resource "azurerm_mssql_firewall_rule" "main" {
  name             = "AllowMyIps"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "24.206.111.172"
  end_ip_address   = "24.206.111.172"
}
