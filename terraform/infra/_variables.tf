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

variable "vm_image_version" {
  type    = string
  default = "4.9.3"
}

variable "admin_user" {
  type    = string
  default = "wowza"
}

variable "os_disk_type" {
  type    = string
  default = "Premium_LRS"
}

variable "os_disk_size" {
  type    = number
  default = 1024
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

variable "vm_names" {
  description = "VMs to include in the automation runbook"
  type        = list(string)
  default     = null
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

variable "delete_after_days_since_creation_greater_than" {
  type        = number
  default     = 90
  description = "Number of days to keep an ingest file for before deleting it. Default 90 days"
}

variable "storage_policy_enabled" {
  type        = bool
  default     = true
  description = "Status of the storage account lifecycle policy. Default 'true'"
}

variable "retention_period" {
  type        = number
  default     = 365
  description = "(Optional) Specifies the number of days that the blob should be retained, between 1 and 365 days. Defaults to 365"
}

variable "storage_allowed_subnets" {
  description = "Resource IDs of subnets to allow through storage firewall"
  type        = list(string)
  default     = null
}

variable "storage_allowed_ips" {
  type        = list(string)
  description = "(Optional) List of public IP addresses which will have access to storage account."
  default     = []
}

variable "default_action" {
  description = "(Optional) Network rules default action"
  default     = "Deny"
}

variable "allow_nested_items_to_be_public" {
  description = "(Optional) Allow or disallow public access to all blobs or containers in the storage account."
  default     = "false"
}

variable "enable_dynatrace" {
  description = "Enable Dynatrace network security rule"
  type        = bool
  default     = false
}

variable "create_vm_schedule" {
  description = "Enable the vm schedule"
  type        = bool
  default     = true
}

variable "dynatrace_allowed_ips" {
  description = "Allowed Dynatrace IPs"
  type        = list(string)
  default = [
    "10.10.80.0/24",
    "51.105.8.19",
    "51.105.13.99",
    "51.105.16.253",
    "51.105.19.65",
    "51.145.2.40",
    "51.145.5.6",
    "51.145.125.238",
    "52.151.104.144",
    "52.151.109.153",
    "52.151.111.195"
  ]
}
