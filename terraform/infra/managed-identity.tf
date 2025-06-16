###############################################################
# Wowza Storage MI. ###########################################
###############################################################

resource "azurerm_user_assigned_identity" "wowza_storage" {
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  name = "wowza-storage-${var.environment}"
  tags = local.common_tags
}

resource "azurerm_role_assignment" "wowza_storage_access" {
  scope                = module.wowza_recordings.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.wowza_storage.principal_id
}

resource "azurerm_role_assignment" "wowza_storage_vh_mi" {
  scope                = module.wowza_recordings.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_user_assigned_identity.vh_mi.principal_id
}

## RPA Access (HRS -> Wowza Storage)

resource "azurerm_role_definition" "blob-tag-writer" {
  count = var.environment == "demo" || var.environment == "prod" ? 1 : 0

  name        = "VH-BLOB-Tag-Writer-${var.environment}"
  scope       = module.wowza_recordings.storageaccount_id
  description = "Custom Role for managing tags in Wowza storage"

  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/read"
    ]
    not_actions = []
    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags/write",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags/read"
    ]
  }

  assignable_scopes = [
    module.wowza_recordings.storageaccount_id,
  ]
}

resource "azurerm_role_assignment" "wowza_storage_rpa_mi_demo" {
  count = var.environment == "demo" ? 1 : 0

  scope                = module.wowza_recordings.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_user_assigned_identity.rpa_mi_demo.principal_id
}

resource "azurerm_role_assignment" "wowza_storage_rpa_mi_prod" {
  count = var.environment == "prod" ? 1 : 0

  scope                = module.wowza_recordings.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_user_assigned_identity.rpa_mi_prod.principal_id
}

resource "azurerm_role_assignment" "wowza-sa-tag-role-demo" {
  count = var.environment == "demo" ? 1 : 0

  scope              = module.wowza_recordings.storageaccount_id
  role_definition_id = azurerm_role_definition.blob-tag-writer[0].role_definition_resource_id
  principal_id       = data.azurerm_user_assigned_identity.rpa_mi_demo.principal_id

  depends_on = [
    azurerm_role_definition.blob-tag-writer
  ]
}

resource "azurerm_role_assignment" "wowza-sa-tag-role-prod" {
  count = var.environment == "prod" ? 1 : 0

  scope              = module.wowza_recordings.storageaccount_id
  role_definition_id = azurerm_role_definition.blob-tag-writer[0].role_definition_resource_id
  principal_id       = data.azurerm_user_assigned_identity.rpa_mi_prod.principal_id

  depends_on = [
    azurerm_role_definition.blob-tag-writer
  ]
}

# ###############################################################
# # Automation Account MI. ######################################
# ###############################################################

# resource "azurerm_user_assigned_identity" "wowza-automation-account-mi" {
#   name                = "wowza-automation-mi-${var.environment}"
#   resource_group_name = azurerm_resource_group.wowza.name
#   location            = azurerm_resource_group.wowza.location

#   tags = local.common_tags
# }

# resource "azurerm_role_definition" "virtual-machine-control" {
#   name        = "Virtual-Machine-Control-${var.environment}"
#   scope       = azurerm_resource_group.wowza.id
#   description = "Custom Role for controlling virtual machines"

#   permissions {
#     actions = [
#       "Microsoft.Compute/virtualMachines/read",
#       "Microsoft.Compute/virtualMachines/start/action",
#       "Microsoft.Compute/virtualMachines/deallocate/action",
#     ]
#     not_actions = []
#   }

#   assignable_scopes = [
#     azurerm_resource_group.wowza.id,
#   ]
# }

# resource "azurerm_role_assignment" "wowza-auto-acct-mi-role" {
#   scope              = azurerm_resource_group.wowza.id
#   role_definition_id = azurerm_role_definition.virtual-machine-control.role_definition_resource_id
#   principal_id       = azurerm_user_assigned_identity.wowza-automation-account-mi.principal_id

#   depends_on = [
#     azurerm_role_definition.virtual-machine-control
#   ]
# }

# ###############################################################
# # Key Vault Access. ###########################################
# ###############################################################

# data "azurerm_key_vault" "acmekv" {
#   name                = "acmedtssds${var.environment}"
#   resource_group_name = "sds-platform-${var.environment}-rg"
# }

resource "azurerm_user_assigned_identity" "wowza_cert" {
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  name = "vh-wowza-cert-${var.environment}-mi"
  tags = local.common_tags
}

resource "azurerm_role_assignment" "kv_access" {
  scope                = data.azurerm_key_vault.acmekv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.wowza_cert.principal_id
}