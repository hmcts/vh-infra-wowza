locals {
  wowza_frontend_ip_name = "Wowza-Ip"
}

###########################################################
# Load Balancer. ##########################################
###########################################################

resource "azurerm_lb" "wowza" {
  name                = var.service_name
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = local.wowza_frontend_ip_name
    subnet_id                     = azurerm_subnet.wowza.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.wowza_lb_private_ip_address
  }

  tags = local.common_tags
}

###########################################################
# Backends. ###############################################
###########################################################

resource "azurerm_lb_backend_address_pool" "wowza" {
  loadbalancer_id = azurerm_lb.wowza.id
  name            = "Wowza-Virtual-Machines"
}

resource "azurerm_lb_backend_address_pool" "wowza_vm" {
  count = var.wowza_instance_count

  loadbalancer_id = azurerm_lb.wowza.id
  name            = "Wowza-Virtual-Machine-${count.index + 1}"
}

resource "azurerm_network_interface_backend_address_pool_association" "wowza" {
  count = var.wowza_instance_count

  network_interface_id    = azurerm_network_interface.wowza[count.index].id
  ip_configuration_name   = "wowzaConfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.wowza.id
}

resource "azurerm_network_interface_backend_address_pool_association" "wowza_vm" {
  count = var.wowza_instance_count

  network_interface_id    = azurerm_network_interface.wowza[count.index].id
  ip_configuration_name   = "wowzaConfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.wowza_vm[count.index].id
}

###########################################################
# Routing Rules. ##########################################
###########################################################

resource "azurerm_lb_rule" "wowza_rest" {
  count = var.wowza_instance_count

  loadbalancer_id                = azurerm_lb.wowza.id
  name                           = "REST-${count.index}"
  protocol                       = "Tcp"
  frontend_port                  = 8090 + count.index
  backend_port                   = 8087
  frontend_ip_configuration_name = local.wowza_frontend_ip_name
  probe_id                       = azurerm_lb_probe.wowza_rest.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.wowza_vm[count.index].id]
}

resource "azurerm_lb_rule" "wowza" {
  loadbalancer_id                = azurerm_lb.wowza.id
  name                           = "RTMPS-Rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = local.wowza_frontend_ip_name
  probe_id                       = azurerm_lb_probe.wowza_rtmps.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.wowza.id]
  load_distribution              = "Default"
  idle_timeout_in_minutes        = 30
}

###########################################################
# Probes. #################################################
###########################################################

resource "azurerm_lb_probe" "wowza_rest" {
  loadbalancer_id = azurerm_lb.wowza.id
  name            = "REST-Probe"
  port            = 8087
}

resource "azurerm_lb_probe" "wowza_rtmps" {
  loadbalancer_id = azurerm_lb.wowza.id
  name            = "RTMPS-Probe"
  port            = 443
}
