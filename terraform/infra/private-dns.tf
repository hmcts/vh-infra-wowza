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
  private_dns_zone_rg = "core-infra-intsvc-rg"
}

data "azurerm_private_dns_zone" "wowza" {
  name                = var.platform_private_dns_zone_name
  resource_group_name = local.private_dns_zone_rg

  provider = azurerm.private-endpoint-dns
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "${azurerm_virtual_network.wowza.name}-link"
  resource_group_name   = local.private_dns_zone_rg
  private_dns_zone_name = data.azurerm_private_dns_zone.wowza.name
  virtual_network_id    = azurerm_virtual_network.wowza.id
  registration_enabled  = false

  tags     = local.common_tags
  provider = azurerm.private-endpoint-dns
}