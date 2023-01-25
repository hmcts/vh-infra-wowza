provider "azurerm" {
  features {}
}

provider "azurerm" { ## TODO: delete after first run. needs to be left in to remove tf state reference
  features {}
  alias = "peering_target"
}

provider "azurerm" {
  features {}
  alias = "peering_target_prod"
}

provider "azurerm" {
  features {}
  alias = "peering_target_nonprod"
}

provider "azurerm" {
  features {}
  alias = "peering_target_vpn"
}

provider "azurerm" {
  features {}
  alias = "peering_client"
}

provider "azurerm" {
  features {}
  alias = "networking_staging"
}

provider "azurerm" {
  features {}
  alias = "networking_prod"
}



provider "azurerm" {
  features {}
  alias = "private-endpoint-dns"
}