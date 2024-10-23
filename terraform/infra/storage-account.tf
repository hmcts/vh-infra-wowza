locals {
  tables = []
  containers = [{
    name        = local.recordings_container_name
    access_type = "private"
  }]
  recordings_container_name = "recordings"
}

#tfsec:ignore:azure-storage-default-action-deny
module "wowza_recordings" {
  source = "git::https://github.com/hmcts/cnp-module-storage-account?ref=4.x"

  env = var.environment

  storage_account_name = replace(lower(var.service_name), "-", "")
  common_tags          = local.common_tags

  default_action = var.sa_default_action

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  access_tier                     = "Cool"
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "RAGRS"
  allow_nested_items_to_be_public = "true"

  enable_data_protection = true
  enable_change_feed     = true
  retention_period       = var.retention_period

  tables     = local.tables
  containers = local.containers
}

# policy created outside of the SA module as the module does not allow for index tags filter
# TODO: add functionallity to module
resource "azurerm_storage_management_policy" "example" {
  storage_account_id = module.wowza_recordings.storageaccount_id

  rule {
    name    = "HRS_Ingest"
    enabled = var.storage_policy_enabled
    filters {
      blob_types = ["blockBlob"]
      match_blob_index_tag {
        name      = "processed"
        operation = "=="
        value     = "true"
      }
      prefix_match = [local.recordings_container_name]
    }
    actions {
      base_blob {
        delete_after_days_since_creation_greater_than = var.delete_after_days_since_creation_greater_than
      }
    }
  }
}

resource "azurerm_private_endpoint" "wowza_storage" {
  name = "${module.wowza_recordings.storageaccount_name}-storage-endpoint"

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  subnet_id = azurerm_subnet.wowza.id

  private_service_connection {
    name                           = "${var.service_name}-privateserviceconnection"
    private_connection_resource_id = module.wowza_recordings.storageaccount_id
    subresource_names              = ["Blob"]
    is_manual_connection           = false
  }
  tags = local.common_tags
}

