terraform {
  required_version = ">=1.0.0"

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2"
    }
  }
}