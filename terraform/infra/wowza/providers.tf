locals {
  peering_prod_subscription    = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"
  peering_nonprod_subscription = "fb084706-583f-4c9a-bdab-949aac66ba5c"
  peering_vpn_subscription     = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}

provider "azurerm" { ## TODO: delete after first run. needs to be left in to remove tf state reference
  features {}
  alias           = "peering_target"
  subscription_id = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}

provider "azurerm" {
  features {}
  alias           = "peering_target_prod"
  subscription_id = local.peering_prod_subscription
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}
provider "azurerm" {
  features {}
  alias           = "peering_target_nonprod"
  subscription_id = local.peering_nonprod_subscription
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}
provider "azurerm" {
  features {}
  alias           = "peering_target_vpn"
  subscription_id = local.peering_vpn_subscription
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}
provider "azurerm" {
  features {}
  alias           = "peering_client"
  subscription_id = data.azurerm_client_config.current.subscription_id
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}
provider "azurerm" {
  features {}
  alias           = "networking_staging"
  subscription_id = "74dacd4f-a248-45bb-a2f0-af700dc4cf68" # SDS STG SUB
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}
provider "azurerm" {
  features {}
  alias           = "networking_prod"
  subscription_id = "5ca62022-6aa2-4cee-aaa7-e7536c8d566c" # SDS PROD SUB
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}



provider "azurerm" {
  features {}
  alias                      = "private-endpoint-dns"
  skip_provider_registration = "true"
  subscription_id            = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}