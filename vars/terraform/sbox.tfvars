location = "uksouth"
service_name = "vh-infra-wowza-sbox"

schedules = [
   {
    name      = "vm-on",
    frequency = "Day"
    interval  = 1
    run_time  = "09:00:00"
    start_vm  = true
  },
  {
    name      = "vm-off",
    frequency = "Day"
    interval  = 1
    run_time  = "18:00:00"
    start_vm  = false
  },
  {
    name      = "vm-off-weekly",
    frequency = "Week"
    interval  = 1
    run_time  = "15:00:00"
    start_vm  = false
    week_days = ["Sunday"]
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