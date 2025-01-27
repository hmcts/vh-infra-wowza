location = "uksouth"

address_space = "10.254.0.224/28"

service_name = "vh-infra-wowza-demo"

schedules = [
  {
    name      = "vm-on",
    frequency = "Week"
    interval  = 1
    run_time  = "08:00:00"
    start_vm  = true
    week_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  },
  {
    name      = "vm-off",
    frequency = "Week"
    interval  = 1
    run_time  = "19:00:00"
    start_vm  = false
    week_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  }
]

vm_names = ["vh-infra-wowza-demo-1", "vh-infra-wowza-demo-2"]

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

wowza_lb_private_ip_address = "10.254.0.232"

aks_address_space = "10.51.64.0/18"

delete_after_days_since_creation_greater_than = 10

storage_allowed_subnets = [
  "/subscriptions/d025fece-ce99-4df2-b7a9-b649d3ff2060/resourceGroups/cft-demo-network-rg/providers/Microsoft.Network/virtualNetworks/cft-demo-vnet/subnets/aks-00",
  "/subscriptions/d025fece-ce99-4df2-b7a9-b649d3ff2060/resourceGroups/cft-demo-network-rg/providers/Microsoft.Network/virtualNetworks/cft-demo-vnet/subnets/aks-01",
  "/subscriptions/c68a4bed-4c3d-4956-af51-4ae164c1957c/resourceGroups/ss-demo-network-rg/providers/Microsoft.Network/virtualNetworks/ss-demo-vnet/subnets/aks-00",
  "/subscriptions/c68a4bed-4c3d-4956-af51-4ae164c1957c/resourceGroups/ss-demo-network-rg/providers/Microsoft.Network/virtualNetworks/ss-demo-vnet/subnets/aks-01"
]

storage_allowed_ips = [
  "128.77.75.64/26",  #GlobalProtect VPN egress range
  "51.149.249.0/29",  #AnyConnect VPN egress range
  "51.149.249.32/29", #AnyConnect VPN egress range
  "194.33.249.0/29",  #AnyConnect VPN egress backup range
  "194.33.248.0/29"   #AnyConnect VPN egress backup range
]
