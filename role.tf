data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

resource "azurerm_role_definition" "rg_reader" {
  name        = "rg_reader"
  scope       = azurerm_resource_group.learning.id
  description = "Custom role to allow read access to resource groups"

  # Demonstrates: resource group scope — access limited to this RG only
  # Principal of least privilege: read-only, no modification rights

}

resource "azurerm_role_assignment" "rg_reader_assignment" {
  principal_id = data.azurerm_client_config.current.object_id
  #role_definition_id = azurerm_role_definition.rg_reader.id
  role_definition_name = "Reader"
  scope                = azurerm_resource_group.learning.id
}

resource "azurerm_role_assignment" "storage_contributor" {
  scope                = azurerm_storage_account.learning.id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Storage Blob Data Contributor"
}

resource "azurerm_role_definition" "vm_operator" {
  name        = "VM Operator - Learning"
  scope       = azurerm_resource_group.learning.id  
  description = "Can start, stop, and restart VMs but cannot create or delete them"

  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/restart/action",
      "Microsoft.Compute/virtualMachines/powerOff/action",
      "Microsoft.Compute/virtualMachines/read"
    ]
    not_actions = []
  }

  assignable_scopes = [azurerm_resource_group.learning.id]
}

resource "azurerm_role_assignment" "vm_operator_assignment" {
  scope                = azurerm_resource_group.learning.id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = azurerm_role_definition.vm_operator.name
  #role_definition_id   = azurerm_role_definition.vm_operator.role_definition_resource_id
}