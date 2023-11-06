resource "azurerm_monitor_diagnostic_setting" "storage_account" {
  name                       = "vh-sa-${var.environment}-diag-set"
  target_resource_id         = module.wowza_recordings.storageaccount_id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id

  metric {
    category = "Capacity"
    enabled  = true
  }
  metric {
    category = "Transaction"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "storage_account_blob" {
  name                       = "vh-sa-${var.environment}-diag-set-blob"
  target_resource_id         = "${module.wowza_recordings.storageaccount_id}/blobServices/default"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id

  enabled_log {
    category = "StorageRead"

  }
  enabled_log {
    category = "StorageWrite"
  }
  enabled_log {
    category = "StorageDelete"
  }
  metric {
    category = "Transaction"
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg" {
  name                       = "vh-nsg-${var.environment}-diag-set"
  target_resource_id         = azurerm_network_security_group.wowza.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"

  }
}

resource "azurerm_monitor_diagnostic_setting" "nics" {
  count = var.wowza_instance_count

  name                       = "vh-nic${count.index + 1}-${var.environment}-diag-set"
  target_resource_id         = azurerm_network_interface.wowza[count.index].id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}


resource "azurerm_monitor_diagnostic_setting" "load_balancer" {
  name                       = "vh-lb-${var.environment}-diag-set"
  target_resource_id         = azurerm_lb.wowza.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id

  enabled_log {
    category = "LoadBalancerAlertEvent"
  }
  enabled_log {
    category = "LoadBalancerProbeHealthStatus"
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "load_balancer_public" {
  name                       = "vh-lb-public-${var.environment}-diag-set"
  target_resource_id         = azurerm_lb.wowza-public.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id

  enabled_log {
    category = "LoadBalancerAlertEvent"
  }
  enabled_log {
    category = "LoadBalancerProbeHealthStatus"
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
