location = "uksouth"
service_name = "vh-infra-wowza-sbox"

schedules = [
  {
    name      = "vm-on",
    frequency = "Week"
    interval  = 1
    run_time  = "07:00:00"
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
    name                   = "ss_sbox_aks"
    address_prefix         = "10.140.0.0/18"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.200.36"
  },
  {
    name                   = "azure_control_plane"
    address_prefix         = "51.145.56.125/32"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = null
  }
]