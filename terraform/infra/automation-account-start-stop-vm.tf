#---------------------------------------------------
# Start/Stop VM runbook (via module)
#---------------------------------------------------
locals {
  vm_names = coalesce(var.vm_names, azurerm_linux_virtual_machine.wowza[*].name)
}

module "vm_automation" {
  source = "git::https://github.com/hmcts/cnp-module-automation-runbook-start-stop-vm"
  count  = var.environment == "prod" ? 0 : 1

  product                 = var.product
  env                     = var.environment
  location                = azurerm_resource_group.wowza.location
  automation_account_name = azurerm_automation_account.vh_infra_wowza.name
  schedules               = var.schedules
  resource_group_name     = azurerm_resource_group.wowza.name
  vm_names                = azurerm_linux_virtual_machine.wowza[*].name
  mi_principal_id         = azurerm_user_assigned_identity.wowza-automation-account-mi.principal_id

  tags = module.ctags.common_tags

  depends_on = [
    azurerm_automation_account.vh_infra_wowza
  ]

}