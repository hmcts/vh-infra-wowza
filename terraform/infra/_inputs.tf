variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "service_name" {
  type = string
}

variable "address_space" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_F8s_v2"
}

variable "admin_user" {
  type    = string
  default = "wowza"
}

variable "os_disk_type" {
  type    = string
  default = "Premium_LRS"
}

variable "key_vault_id" {
  type = string
}

variable "cloud_init_file" {
  description = "The location of the cloud init configuration file."
  type        = string
  default     = "./cloudconfig.tpl"
}

variable "wowza_instance_count" {
  type    = number
  default = 2
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "private_dns_zone_group_name" {}

variable "private_dns_zone_group" {}

# Networking Client Details
variable "network_client_id" {
  description = "Client ID of the GlobalNetworkPeering SP"
  type        = string
}
variable "network_client_secret" {
  description = "Client Secret of the GlobalNetworkPeering SP"
  type        = string
  sensitive   = true
}
variable "network_tenant_id" {
  description = "Client Tenant ID of the GlobalNetworkPeering SP"
  type        = string
}

# Automation start/stop variables
variable "runbook_name" {
  description = "Name of runbook file to be used to schedule VM start / stop"
  type        = string
  default     = "wowza-vm-runbook.ps1"
}

variable "start_time" {
  description = "The time that the Wowza VMs should restart"
  type        = string
  default     = "06:00:00"
}

variable "stop_time" {
  description = "The time that the Wowza VMs should stop"
  type        = string
  default     = "22:00:00"
}

## Automation Accounts
variable "schedules" {
  type = list(object({
    name      = string
    frequency = string
    interval  = number
    run_time  = string
    start_vm  = bool
  }))
  default     = []
  description = "List of Schedules to trigger the VM turn on and/or off."
}

variable "route_table" {
  description = "Route Table routes"
}

variable "dynatrace_tenant" {
  description = "Dynatrace Tenant"
  default     = ""
  type        = string
}

variable "dynatrace_token" {
  description = "Dynatrace Token."
  type        = string
}

variable "wowza_lb_private_ip_address" {
  type        = string
  description = "static ip address given to wowza private lb"
}