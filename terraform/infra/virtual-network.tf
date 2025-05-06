resource "azurerm_virtual_network" "wowza" {
  name                = var.service_name
  address_space       = [var.address_space]
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location
  tags                = local.common_tags
}

resource "azurerm_subnet" "wowza" {
  name                 = "wowza"
  resource_group_name  = azurerm_resource_group.wowza.name
  virtual_network_name = azurerm_virtual_network.wowza.name
  address_prefixes     = [var.address_space]

  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies             = "Enabled"
}
