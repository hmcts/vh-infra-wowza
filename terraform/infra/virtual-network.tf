data "azurerm_client_config" "current" {
}

locals {
  dns_zone_name = var.environment == "prod" ? "platform.hmcts.net" : "sandbox.platform.hmcts.net"
  ip_list       = [for vm in azurerm_linux_virtual_machine.wowza : vm.private_ip_address]
  ip_csv        = join(",", local.ip_list)
}

resource "azurerm_virtual_network" "wowza" {
  name          = var.service_name
  address_space = [var.address_space]

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location
  tags                = local.common_tags
}

resource "azurerm_subnet" "wowza" {
  name                 = "wowza"
  resource_group_name  = azurerm_resource_group.wowza.name
  virtual_network_name = azurerm_virtual_network.wowza.name
  address_prefixes     = [var.address_space]

  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}