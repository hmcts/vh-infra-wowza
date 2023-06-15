location = "uksouth"

address_space = "10.100.197.208/28"

service_name = "vh-infra-wowza-ithc"

schedules = [
  {
    name      = "vm-on",
    frequency = "Week"
    interval  = 1
    run_time  = "06:00:00"
    start_vm  = true
    week_days = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
  },
  {
    name      = "vm-off",
    frequency = "Week"
    interval  = 1
    run_time  = "19:00:00"
    start_vm  = false
    week_days = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
  }
]

route_table = [
  {
    name                   = "ss_ithc_aks"
    address_prefix         = "10.143.0.0/18"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.72.36"
  },
  {
    name                   = "ss_stg_aks"
    address_prefix         = "10.148.0.0/18"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.8.36"
  },
  {
    name                   = "azure_control_plane"
    address_prefix         = "51.145.56.125/32"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = null
  }
]

wowza_lb_private_ip_address = "10.100.197.219"

aks_address_space = "10.143.0.0/18"

wowza_instance_count = 2