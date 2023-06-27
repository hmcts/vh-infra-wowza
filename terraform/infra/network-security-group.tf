resource "azurerm_network_security_group" "wowza" {
  name                = var.service_name
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  tags = local.common_tags

  depends_on = [
    azurerm_linux_virtual_machine.wowza
  ]
}

resource "azurerm_subnet_network_security_group_association" "wowza" {
  subnet_id                 = azurerm_subnet.wowza.id
  network_security_group_id = azurerm_network_security_group.wowza.id
}

resource "azurerm_network_security_rule" "DenyAllAzureLoadBalancerInbound" {
  name                        = "DenyAllAzureLoadBalancerInbound"
  resource_group_name         = azurerm_resource_group.wowza.name
  network_security_group_name = azurerm_network_security_group.wowza.name
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_address_prefix       = "AzureLoadBalancer"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
}

resource "azurerm_network_security_rule" "DenyAllVnetInbound" {
  name                        = "DenyAllVnetInbound"
  resource_group_name         = azurerm_resource_group.wowza.name
  network_security_group_name = azurerm_network_security_group.wowza.name
  priority                    = 4095
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
}

resource "azurerm_network_security_rule" "AllowWowzaSSH" {
  name                        = "AllowWowzaSSH"
  resource_group_name         = azurerm_resource_group.wowza.name
  network_security_group_name = azurerm_network_security_group.wowza.name
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = var.address_space
  source_port_range           = "*"
  destination_address_prefix  = var.address_space
  destination_port_ranges     = ["22"]
}

resource "azurerm_network_security_rule" "AllowPexip" {
  name                        = "AllowPexip"
  resource_group_name         = azurerm_resource_group.wowza.name
  network_security_group_name = azurerm_network_security_group.wowza.name
  priority                    = 1020
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefixes     = ["34.89.88.216", "34.89.25.191", "35.189.100.86", "35.242.170.203", "35.246.8.138", "35.242.163.246", "34.142.82.168", "34.89.72.13", "34.147.186.151", "34.147.143.2"]
  source_port_range           = "*"
  destination_address_prefix  = var.address_space
  destination_port_ranges     = ["443", "8087"]
}

resource "azurerm_network_security_rule" "AllowAKSInbound" {
  name                        = "AllowAKSInbound"
  resource_group_name         = azurerm_resource_group.wowza.name
  network_security_group_name = azurerm_network_security_group.wowza.name
  priority                    = 1030
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = var.aks_address_space
  source_port_range           = "*"
  destination_address_prefix  = var.address_space
  destination_port_ranges     = ["443", "8087"]
}

resource "azurerm_network_security_rule" "AllowAzureLoadBalancerProbes" {
  name                        = "AllowAzureLoadBalancerProbes"
  resource_group_name         = azurerm_resource_group.wowza.name
  network_security_group_name = azurerm_network_security_group.wowza.name
  priority                    = 1050
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "AzureLoadBalancer"
  source_port_range           = "*"
  destination_address_prefix  = var.address_space
  destination_port_ranges     = ["443", "8087", "22"]
}

resource "azurerm_network_security_rule" "AllowWowzaToBlobStorage" {
  name                        = "AllowWowzaToBlobStorage"
  resource_group_name         = azurerm_resource_group.wowza.name
  network_security_group_name = azurerm_network_security_group.wowza.name
  priority                    = 1060
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = var.address_space
  source_port_range           = "*"
  destination_address_prefix  = var.address_space
  destination_port_ranges     = ["443", "80"]
}

resource "azurerm_network_security_rule" "AllowDynatrace" {
  count                       = var.environment == "prod" ? 1 : 0
  name                        = "AllowDynatrace"
  resource_group_name         = azurerm_resource_group.wowza.name
  network_security_group_name = azurerm_network_security_group.wowza.name
  priority                    = 1040
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefixes     = ["51.105.8.19", "51.105.13.99", "51.105.16.253", "51.105.19.65", "51.145.2.40", "51.145.5.6", "51.145.125.238", "52.151.104.144", "52.151.109.153", "52.151.111.195"]
  source_port_range           = "*"
  destination_address_prefix  = var.address_space
  destination_port_range      = "443"
}

resource "azurerm_network_watcher_flow_log" "nsg" {
  name                 = "${var.service_name}-flow-logs"
  network_watcher_name = "NetworkWatcher_${azurerm_resource_group.wowza.location}"
  resource_group_name  = "NetworkWatcherRG"
  location             = data.azurerm_log_analytics_workspace.core.location

  network_security_group_id = azurerm_network_security_group.wowza.id
  storage_account_id        = module.wowza_recordings.storageaccount_id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.core.workspace_id
    workspace_region      = data.azurerm_log_analytics_workspace.core.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.core.id
    interval_in_minutes   = 10
  }

  tags = local.common_tags
}
