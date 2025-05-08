################################################################
# Wowza Blob DNS. ##############################################
################################################################

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.wowza.name
  tags                = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "wowza" {
  name                  = var.service_name
  resource_group_name   = azurerm_resource_group.wowza.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.wowza.id
  registration_enabled  = true
  tags                  = local.common_tags
}

resource "azurerm_private_dns_a_record" "wowza_storage" {
  name                = module.wowza_recordings.storageaccount_name
  zone_name           = azurerm_private_dns_zone.blob.name
  resource_group_name = azurerm_resource_group.wowza.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.wowza_storage.private_service_connection.0.private_ip_address]
  tags                = local.common_tags
}


################################################################
# DNS Links to {env}.platform.hmcts.net. #######################
################################################################

locals {
  domain_env            = var.environment == "prod" ? "" : var.environment == "stg" ? "staging." : "${var.environment}."
  private_dns_zone      = "${local.domain_env}platform.hmcts.net"
  private_root_dns_zone = "platform.hmcts.net"
  private_dns_zone_rg   = "core-infra-intsvc-rg"
}

data "azurerm_private_dns_zone" "wowza" {
  name                = local.private_dns_zone
  resource_group_name = local.private_dns_zone_rg

  provider = azurerm.private-endpoint-dns
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  provider = azurerm.private-endpoint-dns

  name                  = "${azurerm_virtual_network.wowza.name}-link"
  resource_group_name   = local.private_dns_zone_rg
  private_dns_zone_name = data.azurerm_private_dns_zone.wowza.name
  virtual_network_id    = azurerm_virtual_network.wowza.id
  registration_enabled  = false

  tags = local.common_tags
}

data "azurerm_private_dns_zone" "platform" {
  provider = azurerm.private-endpoint-dns

  name                = local.private_root_dns_zone
  resource_group_name = local.private_dns_zone_rg
}

resource "azurerm_private_dns_zone_virtual_network_link" "platform" {
  count    = var.environment == "prod" ? 0 : 1
  provider = azurerm.private-endpoint-dns

  name                  = "${azurerm_virtual_network.wowza.name}-link"
  resource_group_name   = local.private_dns_zone_rg
  private_dns_zone_name = data.azurerm_private_dns_zone.platform.name
  virtual_network_id    = azurerm_virtual_network.wowza.id
  registration_enabled  = false

  tags = local.common_tags
}

data "azurerm_virtual_network" "dynatrace-activegate-vnet-nonprod" {
  count               = var.environment == "prod" ? 0 : 1
  provider            = azurerm.dts-management-nonprod-intsvc
  name                = "dynatrace-activegate-vnet-nonprod"
  resource_group_name = local.private_dns_zone_rg
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link_dynatrace_nonprod" {
  count                 = var.environment == "prod" ? 0 : 1
  provider              = azurerm.private-endpoint-dns
  name                  = "dynatrace-activegate-vnet-nonprod"
  resource_group_name   = local.private_dns_zone_rg
  private_dns_zone_name = data.azurerm_private_dns_zone.wowza.name
  virtual_network_id    = data.azurerm_virtual_network.dynatrace-activegate-vnet-nonprod[0].id
  registration_enabled  = false
  tags                  = local.common_tags
}
