location = "uksouth"

address_space = "10.50.11.16/28"

service_name = "vh-infra-wowza-prod"

schedules = [
  {
    name      = "vm-off",
    frequency = "Day"
    interval  = 1
    run_time  = "20:00:00"
    start_vm  = false
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
  },
  {
    name                   = "dynatrace_prod"
    address_prefix         = "10.10.81.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.8.36"
  }
]
dynatrace_tenant = "ebe20728"

wowza_lb_private_ip_address = "10.50.11.24"

aks_address_space = "10.144.0.0/18"

storage_allowed_subnets = [
  "/subscriptions/8cbc6f36-7c56-4963-9d36-739db5d00b27/resourceGroups/cft-prod-network-rg/providers/Microsoft.Network/virtualNetworks/cft-prod-vnet/subnets/aks-00",
  "/subscriptions/8cbc6f36-7c56-4963-9d36-739db5d00b27/resourceGroups/cft-prod-network-rg/providers/Microsoft.Network/virtualNetworks/cft-prod-vnet/subnets/aks-01",
  "/subscriptions/5ca62022-6aa2-4cee-aaa7-e7536c8d566c/resourceGroups/ss-prod-network-rg/providers/Microsoft.Network/virtualNetworks/ss-prod-vnet/subnets/aks-00",
  "/subscriptions/5ca62022-6aa2-4cee-aaa7-e7536c8d566c/resourceGroups/ss-prod-network-rg/providers/Microsoft.Network/virtualNetworks/ss-prod-vnet/subnets/aks-01"
]

storage_allowed_ips = [
  "128.77.75.64/26",  #GlobalProtect VPN egress range
  "51.149.249.0/29",  #AnyConnect VPN egress range
  "51.149.249.32/29", #AnyConnect VPN egress range
  "194.33.249.0/29",  #AnyConnect VPN egress backup range
  "194.33.248.0/29",  #AnyConnect VPN egress backup range
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

 enable_dynatrace = true

 dynatrace_allowed_ips = [
  "10.10.81.0/24", # Dynatrace Prod ActiveGate VNET
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

default_action = "Allow"
allow_nested_items_to_be_public = "true"
