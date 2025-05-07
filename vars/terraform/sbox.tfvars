location         = "uksouth"
service_name     = "vh-infra-wowza-sbox"
retention_period = 7

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
    name                   = "ss_sbox_aks"
    address_prefix         = "10.140.0.0/18"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.200.36"
  },
  {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
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

# OS disk - E20
os_disk_size = "512"
os_disk_type = "StandardSSD_LRS"

storage_allowed_subnets = [
  "/subscriptions/b72ab7b7-723f-4b18-b6f6-03b0f2c6a1bb/resourceGroups/cft-sbox-network-rg/providers/Microsoft.Network/virtualNetworks/cft-sbox-vnet/subnets/aks-00",
  "/subscriptions/b72ab7b7-723f-4b18-b6f6-03b0f2c6a1bb/resourceGroups/cft-sbox-network-rg/providers/Microsoft.Network/virtualNetworks/cft-sbox-vnet/subnets/aks-01",
  "/subscriptions/74dacd4f-a248-45bb-a2f0-af700dc4cf68/resourceGroups/vh-infra-ado-stg-rg/providers/Microsoft.Network/virtualNetworks/vh-infra-ado-stg-vnet/subnets/vh-infra-ado-stg-snet"
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
