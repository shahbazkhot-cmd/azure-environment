output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.learning.name
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "webapp_url" {
  description = "Public URL of the App Service Web App"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_connection_string" {
  description = "Connection string for the SQL Database"
  value       = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Database=${azurerm_mssql_database.main.name};User ID=${var.sql_admin_username};Password=${random_password.sql.result};Encrypt=true;"
  sensitive   = true
}
