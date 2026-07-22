# ============================================
# Log Analytics Workspace — needed only for log alerts and log storage
# =

# resource "azurerm_log_analytics_workspace" "main" {
#   name                = "log-${local.name_prefix}"
#   location            = azurerm_resource_group.learning.location
#   resource_group_name = azurerm_resource_group.learning.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30

#   tags = local.common_tags
# }

# ============================================
# Action Group — the delivery mechanism for alerts
# ============================================

# resource "azurerm_monitor_action_group" "main" {
#   name                = "ag-${local.name_prefix}"
#   resource_group_name = azurerm_resource_group.learning.name
#   short_name          = "learningAG"

#   email_receiver {
#     name          = "admin-email"
#     email_address = "shahbazkhot@gmail.com" # ← your email address
#   }
#   tags = local.common_tags
# }

# ============================================
# Metric Alert — direct threshold on Storage Account metrics
# (VM would be ideal, but yours is commented out)
# ============================================

# resource "azurerm_monitor_metric_alert" "storage_transactions" {
#   name                = "alert-storage-high-transactions"
#   resource_group_name = azurerm_resource_group.learning.name
#   scopes              = [azurerm_storage_account.learning.id]
#   description         = "Alert when storage account has more than 1000 transactions in 5 minutes"
#   severity            = 2 # 0=critical, 1=error, 2=warning, 3=informational, 4=verbose

#   frequency   = "PT5M" # How often to check — every 5 minutes
#   window_size = "PT5M" # Time window to aggregate — last 5 minutes

#   criteria {
#     metric_namespace = "Microsoft.Storage/storageAccounts"
#     metric_name      = "Transactions"
#     aggregation      = "Total"
#     operator         = "GreaterThan"
#     threshold        = 1000
#   }

#   action {
#     action_group_id = azurerm_monitor_action_group.main.id
#   }

#   tags = local.common_tags
# }

# ============================================
# Diagnostic Setting — route resource group activity to Log Analytics
# ============================================

# resource "azurerm_monitor_diagnostic_setting" "storage" {
#   name                       = "diag-storage"
#   target_resource_id         = "${azurerm_storage_account.learning.id}/blobServices/default"
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

#   enabled_log {
#     category = "StorageRead"
#   }

#   enabled_log {
#     category = "StorageWrite"
#   }

#   metric {
#     category = "Transaction"
#     enabled  = true
#   }
# }