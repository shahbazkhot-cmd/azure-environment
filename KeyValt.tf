# ============================================
# RBAC — grant yourself Administrator on the vault
# ============================================

# resource "random_string" "kv_suffix" {
#   length  = 4
#   upper   = false
#   numeric = true
#   special = false
# }

# ============================================
# Key Vault — the core resource
# ============================================

# resource "azurerm_key_vault" "main" {
#   name                = "kv-learning-${random_string.kv_suffix.result}"
#   location            = azurerm_resource_group.learning.location
#   resource_group_name = azurerm_resource_group.learning.name
#   tenant_id           = data.azurerm_client_config.current.tenant_id
#   sku_name            = "standard"

#   # Use Azure RBAC instead of legacy Access Policies
#   enable_rbac_authorization = true

#   # Security features — enabled by default in production
#   purge_protection_enabled   = false # false for learning; MUST be true in production
#   soft_delete_retention_days = 7     # minimum allowed value

#   tags = local.common_tags
# }

# ============================================
# RBAC — grant yourself Administrator on the vault
# ============================================

# resource "azurerm_role_assignment" "kv_admin" {
#   scope                = azurerm_key_vault.main.id
#   role_definition_name = "Key Vault Administrator"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# resource "random_password" "sql_admin" {
#   length           = 16
#   special          = true
#   override_special = "!#$%"
#   min_upper        = 2
#   min_lower        = 2
#   min_numeric      = 2
#   min_special      = 2
# }

# resource "azurerm_mssql_server" "main" {
#   name                         = "sqlserver-learning-shahbaz1"
#   resource_group_name          = azurerm_resource_group.learning.name
#   location                     = var.sql_location # ← was var.location
#   version                      = "12.0"
#   administrator_login          = "sqladmin"
#   administrator_login_password = random_password.sql.result

#   tags = local.common_tags
# }
