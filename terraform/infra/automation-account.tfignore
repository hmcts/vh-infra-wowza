resource "azurerm_automation_account" "vh_infra_wowza" {
  name                = "vh-infra-wowza-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.wowza.name
  sku_name            = "Basic"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.wowza-automation-account-mi.id]
  }

  tags = local.common_tags
}