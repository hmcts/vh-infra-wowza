data "azurerm_monitor_action_group" "dev" {
  resource_group_name = "vh-infra-core-${var.environment}"
  name                = "Vh-Action-Group-dev-${var.environment}"
}

data "azurerm_monitor_action_group" "devops" {
  resource_group_name = "vh-infra-core-${var.environment}"
  name                = "Vh-Action-Group-devops-${var.environment}"
}

locals {
  wowzaLoadBalancers = {
    private = {
      scope      = [azurerm_lb.wowza.id]
      name       = "Wowza Private Load Balancer ${title(var.environment)}"
      lb_name    = azurerm_lb.wowza.name
      short_name = "PublicLB"
    }
    public = {
      scope      = [azurerm_lb.wowza-public.id]
      name       = "Wowza Public Load Balancer ${title(var.environment)}"
      lb_name    = azurerm_lb.wowza-public.name
      short_name = "PrivLB"
    }
  }
}

resource "azurerm_monitor_metric_alert" "wowza_lb_alert" {
  #for_each = var.environment == "prod" ? local.wowzaLoadBalancers : {}
  for_each = local.wowzaLoadBalancers

  name                = "VH - SDS - ${each.value.name}"
  resource_group_name = azurerm_resource_group.wowza.name
  scopes              = each.value.scope
  description         = "Wowza Load Balancer Health is Below 95%, Please Investigate ASAP as this may impact the service."
  tags                = local.common_tags

  criteria {
    metric_namespace = "Microsoft.Network/loadBalancers"
    metric_name      = "DipAvailability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 95
  }

  severity    = 2
  frequency   = "PT5M"
  window_size = "PT5M"

  action {
    action_group_id = data.azurerm_monitor_action_group.dev.id
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.devops.id
  }
}

resource "azurerm_automation_webhook" "webhook" {
  #for_each = var.environment == "prod" ? local.wowzaLoadBalancers : {}
  for_each = local.wowzaLoadBalancers

  name                    = each.value.name
  resource_group_name     = azurerm_resource_group.wowza.name
  automation_account_name = azurerm_automation_account.vh_infra_wowza.name
  expiry_time             = "2028-12-31T00:00:00Z"
  enabled                 = true
  runbook_name            = module.dynatrace_runbook.runbook_name

  parameters = {
    dynatracetenant  = "yrk32651"
    credentialname   = "Dynatrace-Token"
    alertname        = "VH - SDS - ${each.value.name}"
    alertdescription = "Wowza Load Balancer Health is Below 95%, Please Investigate ASAP as this may impact the service."
    entitytype       = "AZURE_LOAD_BALANCER"
    entityname       = each.value.lb_name
    eventype         = "ERROR_EVENT"
  }
}

resource "azurerm_monitor_action_group" "lb_action_group" {
  #for_each = var.environment == "prod" ? local.wowzaLoadBalancers : {}
  for_each = local.wowzaLoadBalancers

  name                = each.value.lb_name
  short_name          = each.value.short_name
  resource_group_name = azurerm_resource_group.wowza.name

  automation_runbook_receiver {
    name                    = each.value.name
    automation_account_id   = azurerm_automation_account.vh_infra_wowza.id
    runbook_name            = module.dynatrace_runbook.runbook_name
    webhook_resource_id     = azurerm_automation_webhook.webhook[each.key].id
    is_global_runbook       = true
    service_uri             = azurerm_automation_webhook.webhook[each.key].uri
    use_common_alert_schema = false
  }
}