
resource "azurerm_automation_account" "vh_infra_wowza" {

  name                = "vh-infra-wowza-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.wowza.name
  sku_name            = "Basic"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.wowza-automation-account-mi.id]
  }

  tags = var.tags
}

# module "vm_automation" {
#   source = "git::https://github.com/hmcts/cnp-module-automation-runbook-start-stop-vm"

#   product                 = "vh-wowza"
#   env                     = var.environment
#   location                = var.location
#   automation_account_name = azurerm_automation_account.vm-start-stop.name
#   tags                    = var.tags
#   schedules               = var.schedules
#   resource_group_name     = azurerm_resource_group.wowza.name
#   vm_names = [
#     for wowza_vm in azurerm_linux_virtual_machine.wowza : wowza_vm.name
#   ]
#   mi_principal_id = azurerm_user_assigned_identity.wowza-automation-account-mi.principal_id
# }

module "dynatrace_runbook" {
  source = "git::https://github.com/hmcts/cnp-module-automation-runbook-new-dynatrace-alert.git?ref=v1.0.0"

  automation_account_name = azurerm_automation_account.vh_infra_wowza.name
  resource_group_name     = azurerm_resource_group.wowza.name
  location                = azurerm_resource_group.wowza.location

  automation_credentials = [
    {
      name        = "Dynatrace-Token"
      username    = "Dynatrace"
      password    = var.dynatrace_token
      description = "Dynatrace API Token"
    }
  ]

  tags = var.tags

  depends_on = [
    azurerm_automation_account.vh_infra_wowza
  ]
}