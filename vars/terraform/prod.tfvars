location = "uksouth"

address_space = "10.50.11.16/28"

service_name = "vh-infra-wowza-prod"

schedules = [
  {
    name      = "vm-on",
    frequency = "Day"
    interval  = 1
    run_time  = "06:00:00"
    start_vm  = true
  }
]
route_table = [
  {
    name                   = "azure_control_plane"
    address_prefix         = "51.145.56.125/32"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = null
  },
  {
    name                   = "ss_prod_aks"
    address_prefix         = "10.144.0.0/18"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.8.36"
  },
  {
    name                   = "soc-prod-vnet"
    address_prefix         = "10.146.0.0/21"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.8.36"
  }
]
dynatrace_tenant = "ebe20728"

wowza_lb_private_ip_address = "10.50.11.24"

aks_address_space = "10.144.0.0/18"

vm_image_version = "4.8.25"
