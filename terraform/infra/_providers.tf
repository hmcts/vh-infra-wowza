provider "azurerm" {
  storage_use_azuread = true
  features {}
}

provider "azurerm" {
  features {}
  alias           = "private-endpoint-dns"
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}

provider "azurerm" {
  features {}
  alias           = "hearings-dns"
  subscription_id = "4bb049c8-33f3-4860-91b4-9ee45375cc18"
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
  alias           = "dcd-cnp-prod"
  subscription_id = "8999dec3-0104-4a27-94ee-6588559729d1" # dcd-cnp-PROD
}

provider "azurerm" {
  features {}
  alias           = "dcd-cnp-demo"
  subscription_id = "1c4f0704-a29e-403d-b719-b90c34ef14c9" # dcd-cnp-DEV
}

# DTS-MANAGEMENT-NONPROD-INTSVC/DTS-MANAGEMENT-PROD-INTSVC
provider "azurerm" {
  features {}
  alias                           = "dts-management-nonprod-intsvc"
  subscription_id                 = var.environment == "prod" ? "2b1afc19-5ca9-4796-a56f-574a58670244" : "b44eb479-9ae2-42e7-9c63-f3c599719b6f"
  resource_provider_registrations = "none"
}
