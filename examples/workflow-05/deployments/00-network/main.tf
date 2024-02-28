provider "azurerm" {  
  features {}  
}  

locals {
  tags =  tomap({
    "environment": terraform.workspace
    }
  )
  vnet_rg = "${var.vnet_name[terraform.workspace]}-rg"
}

resource "azurerm_resource_group" "rg" {  
  name     = local.vnet_rg
  location = var.location
}  
  
resource "azurerm_virtual_network" "vnet" {  
  name                = var.vnet_name[terraform.workspace]
  location            = azurerm_resource_group.rg.location  
  resource_group_name = azurerm_resource_group.rg.name  
  address_space       = [var.vnet_address_space[terraform.workspace]]
  subnet{
    name                 = var.vnet_subnet_name
    address_prefix       = var.vnet_address_space[terraform.workspace]
  }
  tags = local.tags
}  

output "default_subnet_id" {  
  value = "${azurerm_virtual_network.vnet.id}/subnets/${var.vnet_subnet_name}"
}