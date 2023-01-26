module "dynatrace_runbook" {
  source = "git::https://github.com/hmcts/cnp-module-automation-runbook-new-dynatrace-alert.git?ref=v1.0.0"
  count  = var.environment == "prod" || var.environment == "stg" ? 1 : 0

  automation_account_name = azurerm_automation_account.vh_infra_wowza.name
  resource_group_name     = azurerm_resource_group.wowza.name
  location                = azurerm_resource_group.wowza.location

  automation_credentials = [
    {
      name        = "Dynatrace-Token"
      username    = "Dynatrace"
      password    = data.azurerm_key_vault_secret.dynatrace_token.value
      description = "Dynatrace API Token"
    }
  ]

  tags = local.common_tags

  depends_on = [
    azurerm_automation_account.vh_infra_wowza
  ]
}