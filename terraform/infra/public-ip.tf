resource "azurerm_public_ip" "wowza" {
  name                = var.service_name
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
  domain_name_label   = var.service_name
}