location = "uksouth"

address_space = "10.100.197.208/28"

service_name = "vh-infra-wowza-ithc"

schedules = [
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

# OS disk - E20
os_disk_size = "512"
os_disk_type = "StandardSSD_LRS"

dcd_cnp_subscription = "1c4f0704-a29e-403d-b719-b90c34ef14c9"

storage_allowed_subnets = [
  "/subscriptions/62864d44-5da9-4ae9-89e7-0cf33942fa09/resourceGroups/cft-ithc-network-rg/providers/Microsoft.Network/virtualNetworks/cft-ithc-vnet/subnets/aks-00",
  "/subscriptions/62864d44-5da9-4ae9-89e7-0cf33942fa09/resourceGroups/cft-ithc-network-rg/providers/Microsoft.Network/virtualNetworks/cft-ithc-vnet/subnets/aks-01"
  # "/subscriptions/ba71a911-e0d6-4776-a1a6-079af1df7139/resourceGroups/ss-ithc-network-rg/providers/Microsoft.Network/virtualNetworks/ss-ithc-vnet/subnets/aks-00",
  # "/subscriptions/ba71a911-e0d6-4776-a1a6-079af1df7139/resourceGroups/ss-ithc-network-rg/providers/Microsoft.Network/virtualNetworks/ss-ithc-vnet/subnets/aks-01"
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
