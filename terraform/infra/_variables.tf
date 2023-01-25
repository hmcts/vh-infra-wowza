variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "service_name" {
  type = string
}

variable "builtFrom" {
  type = string
}

variable "activity_name" {
  type    = string
  default = "VH"
}

variable "project" {
  type = string
}

variable "product" {
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

variable "cloud_init_file" {
  description = "The location of the cloud init configuration file."
  type        = string
  default     = "./cloudconfig.tpl"
}

variable "wowza_instance_count" {
  type    = number
  default = 2
}

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
  type        = list(map(string))
}

variable "dynatrace_tenant" {
  description = "Dynatrace Tenant"
  default     = ""
  type        = string
}

variable "wowza_lb_private_ip_address" {
  type        = string
  description = "static ip address given to wowza private lb"
}