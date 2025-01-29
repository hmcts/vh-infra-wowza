data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "vh-infra-core" {
  name = "vh-infra-core-${var.environment}"
}

data "azurerm_key_vault_secret" "dynatrace_token" {
  name         = "dynatrace-token"
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
}

data "azurerm_key_vault" "vh-infra-core" {
  name                = "vh-infra-core-${var.environment}"
  resource_group_name = data.azurerm_resource_group.vh-infra-core.name
}

# data "azurerm_key_vault_certificate" "vh-wildcard" {
#   name         = "wildcard-hearings-reform-hmcts-net"
#   key_vault_id = data.azurerm_key_vault.vh-infra-core.id
# }

data "azurerm_private_dns_zone" "core-infra-intsvc" {
  provider            = azurerm.private-endpoint-dns
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "core-infra-intsvc-rg"
}

data "azurerm_log_analytics_workspace" "core" {
  name                = "vh-infra-core-${var.environment}"
  resource_group_name = "vh-infra-core-${var.environment}"
}

data "azurerm_user_assigned_identity" "vh_mi" {
  name                = "vh-${var.environment}-mi"
  resource_group_name = "managed-identities-${var.environment}-rg"
}

data "azurerm_user_assigned_identity" "rpa_mi_demo" {
  provider = azurerm.dcd-cnp-demo

  name                = "rpa-demo-mi"
  resource_group_name = "managed-identities-demo-rg"
}

data "azurerm_user_assigned_identity" "rpa_mi_prod" {
  provider = azurerm.dcd-cnp-prod

  name                = "rpa-prod-mi"
  resource_group_name = "managed-identities-prod-rg"
}

# data "azuread_group" "dts_vh_contributors_prod" {
#   display_name = "DTS VH Contributor (env:production)"
# }

# data "azuread_group" "dts_vh_storage_blob_data_contributors_prod" {
#   display_name = "DTS VH Wowza Storage Blob Data Reader (env:prod)"
# }

data "azuread_group" "dts_cvp_contributors" {
  display_name = "DTS CVP Contributors"
}

output "cvp_group_id" {
  value = data.azuread_group.dts_cvp_contributors.object_id 
}