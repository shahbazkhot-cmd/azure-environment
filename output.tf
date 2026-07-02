# Output = print a useful value after apply (like AWS "outputs")
output "stage_account_name" {
  value = azurerm_storage_account.learning.name
}

output "vm_public_ip" {
  value = azurerm_public_ip.main.ip_address
}

output "website_url" {
  value = "https://${azurerm_linux_web_app.main.default_hostname}"

}

# output "sql_server_fqdn" {
#   value = azurerm_mssql_server.main.fully_qualified_domain_name
# }

# output "sql_connection_string" {
#   value     = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Database=sqldb-learning;User ID=sqladmin;Password=${random_password.sql.result};Encrypt=true;"
#   sensitive = true
# }