location = "uksouth"

address_space = "10.50.10.112/28"

service_name = "vh-infra-wowza-stg"

schedules = [
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
    name                   = "azure_control_plane"
    address_prefix         = "51.145.56.125/32"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = null
  },
  {
    name                   = "ss_stg_aks"
    address_prefix         = "10.148.0.0/18"
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
dcd_cnp_subscription = "1c4f0704-a29e-403d-b719-b90c34ef14c9"

dynatrace_tenant = "yrk32651"

wowza_lb_private_ip_address = "10.50.10.120"

# OS disk - E20
os_disk_size = "512"
os_disk_type = "StandardSSD_LRS"

aks_address_space = "10.148.0.0/18"
