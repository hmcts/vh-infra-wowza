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
  default = "Standard_D4ds_v5"
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
    name       = string
    frequency  = string
    interval   = number
    run_time   = string
    start_vm   = bool
    week_days  = optional(list(string))
    month_days = optional(list(number))
    monthly_occurrence = optional(object({
      day        = optional(string)
      occurrence = optional(number)
    }))
  }))
  default     = []
  description = "(Required) Start/Stop schedule for VM(s)."
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

variable "aks_address_space" {
  type        = string
  description = "address range for aks clusters in the given environment"
}

variable "dcd_cnp_subscription" {
  type    = string
  default = ""
}

variable "sa_default_action" {
  type    = string
  default = "Allow"
}

variable "delete_after_days_since_creation_greater_than" {
  type        = number
  default     = 90
  description = "Number of days to keep an ingest file for before deleting it. Default 90 days"
}

variable "storage_policy_enabled" {
  type        = bool
  default     = false
  description = "Status of the storage account lifecycle policy. Default 'false'"
}
