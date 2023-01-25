location = "uksouth"

address_space = "10.254.0.224/28"

service_name = "vh-infra-wowza-demo"

dns_zone_name                  = "hearings.reform.hmcts.net"

schedules = [
  {
    name      = "vm-on"
    frequency = "Day"
    interval  = 1
    run_time  = "06:00:00"
    start_vm  = true
  },
  {
    name      = "vm-off"
    frequency = "Day"
    interval  = 1
    run_time  = "18:00:00"
    start_vm  = false
  }
]

route_table = [
  {
    name                   = "ss_demo_aks"
    address_prefix         = "10.51.64.0/18"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.72.36"
  },
  {
    name                   = "azure_control_plane"
    address_prefix         = "51.145.56.125/32"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = null
  }
]

wowza_lb_private_ip_address = "10.254.0.235"