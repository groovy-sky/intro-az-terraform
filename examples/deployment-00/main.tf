provider "azurerm" {    
  features {}  
} 

locals {
  default_location = "West Europe"
}

output "location" {
  value = local.default_location
}