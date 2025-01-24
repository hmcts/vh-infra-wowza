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
  source_address_prefixes = [
    "35.246.58.208",
    "34.147.202.145",
    "34.142.32.202",
    "35.189.123.50",
    "35.242.186.8",
    "34.105.207.180",
    "35.234.141.208",
    "34.89.25.191",
    "35.189.100.86",
    "35.234.145.227",
    "34.89.88.69",
    "34.147.159.73",
    "35.234.145.196",
    "35.242.170.203",
    "35.246.8.138",
    "34.89.88.216",
    "35.242.163.246",
    "34.89.118.38",
    "34.89.63.94",
    "35.214.109.205",
    "35.214.109.94",
    "35.214.13.62",
    "35.214.26.11",
    "35.214.49.2",
    "35.214.75.176",
    "35.214.93.136",
    "35.214.94.191"
  ]
  source_port_range          = "*"
  destination_address_prefix = var.address_space
  destination_port_ranges    = ["443", "8087"]
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

resource "azurerm_network_security_rule" "AllowGlobalConnectVPNSSH" {
  count                       = var.environment == "prod" ? 1 : 0
  name                        = "Allow_GlobalConnect_VPN_SSH"
  resource_group_name         = azurerm_resource_group.wowza.name
  network_security_group_name = azurerm_network_security_group.wowza.name
  priority                    = 1070
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "128.77.75.64/26"
  source_port_range           = "*"
  destination_address_prefix  = var.address_space
  destination_port_range      = "22"
}

resource "azurerm_network_security_rule" "AllowAnyConnectVPNSSH" {
  count                       = var.environment == "prod" ? 1 : 0
  name                        = "Allow_AnyConnect_VPN_SSH"
  resource_group_name         = azurerm_resource_group.wowza.name
  network_security_group_name = azurerm_network_security_group.wowza.name
  priority                    = 1080
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefixes = [
    "51.149.249.0/29",
    "51.149.249.32/29",
    "194.33.249.0/29",
    "194.33.248.0/29"
  ]
  source_port_range          = "*"
  destination_address_prefix = var.address_space
  destination_port_range     = "22"
}

resource "azurerm_network_security_rule" "AllowF5VPNSSH" {
  count                       = var.environment == "prod" ? 1 : 0
  name                        = "Allow_F5_VPN_SSH"
  resource_group_name         = azurerm_resource_group.wowza.name
  network_security_group_name = azurerm_network_security_group.wowza.name
  priority                    = 1090
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "10.99.72.4/32"
  source_port_range           = "*"
  destination_address_prefix  = var.address_space
  destination_port_range      = "22"
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
