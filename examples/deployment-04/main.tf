provider "azurerm" {  
  features {}  
}  

variable "location" {  
  description = "The location where all resources should be created"  
  type        = string  
  default     = "West Europe"  
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
  vnet_rg = "deployment-04-${terraform.workspace}-rg"
}

resource "azurerm_resource_group" "rg" {  
  name     = local.vnet_rg
  location = var.location
}  
  
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

output "default_subnet_id" {  
  value = "${azurerm_virtual_network.vnet.id}/subnets/${var.vnet_subnet_name}"
}