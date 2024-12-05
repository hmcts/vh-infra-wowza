location = "uksouth"

address_space = "10.100.198.64/28"

service_name = "vh-infra-wowza-dev"
retention_period = 14

schedules = [
  {
    name      = "vm-on",
    frequency = "Week"
    interval  = 1
    run_time  = "08:00:00"
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
    name                   = "ss_dev_aks"
    address_prefix         = "10.145.0.0/18"
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
dcd_cnp_subscription = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
wowza_lb_private_ip_address = "10.100.198.71"

aks_address_space = "10.145.0.0/18"

wowza_instance_count = 1

# OS disk - E20
os_disk_size = "512"
os_disk_type = "StandardSSD_LRS"

storage_allowed_subnets = [
  "/subscriptions/8b6ea922-0862-443e-af15-6056e1c9b9a4/resourceGroups/cft-preview-network-rg/providers/Microsoft.Network/virtualNetworks/cft-preview-vnet/subnets/aks-00",
  "/subscriptions/8b6ea922-0862-443e-af15-6056e1c9b9a4/resourceGroups/cft-preview-network-rg/providers/Microsoft.Network/virtualNetworks/cft-preview-vnet/subnets/aks-01"
]