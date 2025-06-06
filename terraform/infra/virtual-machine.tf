locals {
  publisher = "wowza"
  offer     = "wowzastreamingengine"
  sku       = "linux-paid-4-8"
}

##########################################################
# NIC. ###################################################
##########################################################

resource "azurerm_network_interface" "wowza" {
  count = var.wowza_instance_count

  name                  = "${var.service_name}_${count.index + 1}"
  resource_group_name   = azurerm_resource_group.wowza.name
  location              = azurerm_resource_group.wowza.location
  ip_forwarding_enabled = false

  ip_configuration {
    name                          = "wowzaConfiguration"
    subnet_id                     = azurerm_subnet.wowza.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.common_tags
}

##########################################################
# Virtual Machine. #######################################
##########################################################

resource "tls_private_key" "vm" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "wowza" {
  count = var.wowza_instance_count

  name                = "${var.service_name}-${count.index + 1}"
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  size           = var.vm_size
  admin_username = var.admin_user

  network_interface_ids = [
    azurerm_network_interface.wowza[count.index].id,
  ]

  admin_ssh_key {
    username   = var.admin_user
    public_key = tls_private_key.vm.public_key_openssh
  }

  os_disk {
    name                 = "${var.service_name}-${count.index + 1}-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size
  }

  provision_vm_agent = true

  custom_data = data.template_cloudinit_config.wowza_setup.rendered

  source_image_reference {
    publisher = local.publisher
    offer     = local.offer
    sku       = local.sku
    version   = var.vm_image_version
  }

  plan {
    name      = local.sku
    product   = local.offer
    publisher = local.publisher
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.wowza_storage.id,
      azurerm_user_assigned_identity.wowza_cert.id
    ]
  }

  tags = local.common_tags

  depends_on = [
    azurerm_private_dns_a_record.wowza_storage,
    azurerm_private_dns_zone_virtual_network_link.wowza
  ]
}
