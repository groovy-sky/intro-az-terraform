provider "azurerm" {    
  features {}  
}

variable "vnet_address_space" {  
  type        = map(string)  
}

variable "vnet_subnet_name" {  
  type        = string
  default = "default"
}

locals {
  tags =  tomap({
    "environment": terraform.workspace
    }
  )
  environment = terraform.workspace
  vnet_rg = "${basename(abspath(path.module))}-${terraform.workspace}-rg"
  location = "West Europe"
}

// Create a resource group
resource "azurerm_resource_group" "rg" {  
  name     = local.vnet_rg
  location = local.location
}  

// Create a virtual network
resource "azurerm_virtual_network" "vnet" {  
  name                = "${local.environment}-vnet"
  location            = azurerm_resource_group.rg.location  
  resource_group_name = azurerm_resource_group.rg.name  
  address_space       = [var.vnet_address_space[local.environment]]
  subnet{
    name                 = var.vnet_subnet_name
    address_prefix       = var.vnet_address_space[local.environment]
  }
  tags = local.tags
}  

// Output the subnet ID
output "default_subnet_id" {  
  value = "${azurerm_virtual_network.vnet.id}/subnets/${var.vnet_subnet_name}"
}