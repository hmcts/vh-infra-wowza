#--------------------------------------------------------------
# VH - Key Vault Lookup
#--------------------------------------------------------------

data "azurerm_key_vault_secret" "dynatrace_token" {
  name         = "dynatrace-token"
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
}

data "azurerm_key_vault" "vh-infra-core" {
  name                = "vh-infra-core-${var.environment}"
  resource_group_name = data.azurerm_resource_group.vh-infra-core.name
}

data "azurerm_key_vault_certificate" "vh-wildcard" {
  name         = "wildcard-hearings-reform-hmcts-net"
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
}

output "certificate_thumbprint" {
  value = data.azurerm_key_vault_certificate.vh-wildcard.thumbprint
}


#--------------------------------------------------------------
# VH - Wowza
#--------------------------------------------------------------

data "azurerm_private_dns_zone" "core-infra-intsvc" {
  provider            = azurerm.private-endpoint-dns
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "core-infra-intsvc-rg"
}

resource "azurerm_resource_group" "wowza" {
  name     = var.service_name
  location = var.location
  tags     = local.common_tags
}

data "azurerm_log_analytics_workspace" "core" {
  name                = "vh-infra-core-${var.environment}"
  resource_group_name = "vh-infra-core-${var.environment}"
}