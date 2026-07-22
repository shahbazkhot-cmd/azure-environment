# ============================================
# Recovery Services Vault — the container for all backups
# ============================================

# resource "azurerm_recovery_services_vault" "main" {
#   name                = "rsv-${local.name_prefix}"
#   location            = azurerm_resource_group.learning.location
#   resource_group_name = azurerm_resource_group.learning.name
#   sku                 = "Standard"

#   # Soft delete protects backups from accidental/malicious deletion
#   soft_delete_enabled = true

#   # Storage redundancy for the backup data itself
#   storage_mode_type = "GeoRedundant" # cross-region durability

#   tags = local.common_tags
# }

# ============================================
# VM Backup Policy — defines WHEN backups run and HOW LONG they're kept
# ============================================

# resource "azurerm_backup_policy_vm" "daily" {
#   name                = "policy-vm-daily"
#   resource_group_name = azurerm_resource_group.learning.name
#   recovery_vault_name = azurerm_recovery_services_vault.main.name

#   # WHEN — backup schedule
#   backup {
#     frequency = "Daily"
#     time      = "02:00" # 2 AM — the RPO driver
#   }

#   # HOW LONG — retention tiers
#   retention_daily {
#     count = 30 # keep daily backups for 30 days
#   }

#   retention_weekly {
#     count    = 12
#     weekdays = ["Sunday"]
#   }

#   retention_monthly {
#     count    = 12
#     weekdays = ["Sunday"]
#     weeks    = ["First"]
#   }
# }