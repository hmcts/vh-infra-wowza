data "azurerm_subnet" "ss_subnet" {
  name                 = "vh_private_endpoints"
  virtual_network_name = "ss-${var.environment}-vnet"
  resource_group_name  = "ss-${var.environment}-network-rg"
}

resource "azurerm_private_endpoint" "wowza_storage_endpoint_aks" {
  name                = "vh-wowza-aks-storage-endpoint-${var.environment}"
  location            = azurerm_resource_group.wowza.location
  resource_group_name = azurerm_resource_group.wowza.name
  subnet_id           = data.azurerm_subnet.ss_subnet.id

  private_service_connection {
    name                           = "wowza-${var.environment}-storageconnection"
    private_connection_resource_id = module.wowza_recordings.storageaccount_id
    subresource_names              = ["Blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "vh-wowza-aks-storage-endpoint-${var.environment}-dnszonegroup"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.core-infra-intsvc.id]
  }

  tags = local.common_tags
}

resource "azurerm_private_dns_a_record" "wowza_storage_endpoint_dns" {
  provider            = azurerm.private-endpoint-dns
  name                = "vh-wowza-storage-${var.environment}"
  zone_name           = data.azurerm_private_dns_zone.core-infra-intsvc.name
  resource_group_name = "core-infra-intsvc-rg" #"vh-hearings-reform-hmcts-net-dns-zone"
  ttl                 = 300
  records             = [azurerm_private_endpoint.wowza_storage_endpoint_aks.private_service_connection[0].private_ip_address]
}