resource "azurerm_resource_group" "wowza" {
  name     = var.service_name
  location = var.location
  tags     = local.common_tags
}

###############################################################
# Wowza RG Group Access #######################################
###############################################################

resource "azurerm_role_assignment" "dts_vh_contributors_prod_access" {
  count                = var.environment == "prod" ? 1 : 0
  scope                = azurerm_resource_group.wowza.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_group.dts_vh_contributors_prod.object_id
}