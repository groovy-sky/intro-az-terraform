provider "azurerm" {    
  features {}  
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {
    storage_account_name  = "z5voe4w7azxp6"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}