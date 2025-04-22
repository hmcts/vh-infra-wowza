location = "uksouth"

address_space = "10.23.255.208/28"

service_name = "vh-infra-wowza-test"

schedules = [
  {
    name      = "vm-on",
    frequency = "Week"
    interval  = 1
    run_time  = "07:00:00"
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

route_table = [
  {
    name                   = "ss_test_aks"
    address_prefix         = "10.141.0.0/18"
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
    name                   = "ss_test_aks_perf_test"
    address_prefix         = "10.24.0.112/28"
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
dcd_cnp_subscription = "1c4f0704-a29e-403d-b719-b90c34ef14c9"

wowza_lb_private_ip_address = "10.23.255.216"

aks_address_space = "10.141.0.0/18"

storage_allowed_subnets = [
  "/subscriptions/8a07fdcd-6abd-48b3-ad88-ff737a4b9e3c/resourceGroups/cft-perftest-network-rg/providers/Microsoft.Network/virtualNetworks/cft-perftest-vnet/subnets/aks-00",
  "/subscriptions/8a07fdcd-6abd-48b3-ad88-ff737a4b9e3c/resourceGroups/cft-perftest-network-rg/providers/Microsoft.Network/virtualNetworks/cft-perftest-vnet/subnets/aks-01",
  "/subscriptions/74dacd4f-a248-45bb-a2f0-af700dc4cf68/resourceGroups/vh-infra-ado-stg-rg/providers/Microsoft.Network/virtualNetworks/vh-infra-ado-stg-vnet/subnets/vh-infra-ado-stg-snet"
]

storage_allowed_ips = [
  "128.77.75.64/26",  #GlobalProtect VPN egress range
  "51.149.249.0/29",  #AnyConnect VPN egress range
  "51.149.249.32/29", #AnyConnect VPN egress range
  "194.33.249.0/29",  #AnyConnect VPN egress backup range
  "194.33.248.0/29"   #AnyConnect VPN egress backup range
  "13.107.6.0/24",    #Azure DevOps Agent outbound range
  "13.107.9.0/24",    #Azure DevOps Agent outbound range
  "13.107.42.0/24",   #Azure DevOps Agent outbound range
  "13.107.43.0/24",   #Azure DevOps Agent outbound range
  "150.171.22.0/24",  #Azure DevOps Agent outbound range
  "150.171.23.0/24",  #Azure DevOps Agent outbound range
  "150.171.73.0/24",  #Azure DevOps Agent outbound range
  "150.171.74.0/24",  #Azure DevOps Agent outbound range
  "150.171.75.0/24",  #Azure DevOps Agent outbound range
  "150.171.76.0/24"   #Azure DevOps Agent outbound range
]