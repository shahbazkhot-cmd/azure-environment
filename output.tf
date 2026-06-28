# Output = print a useful value after apply (like AWS "outputs")
output "stage_account_name" {
  value = azurerm_storage_account.learning.name
}

output "vm_public_ip" {
  value = azurerm_public_ip.main.ip_address
}
