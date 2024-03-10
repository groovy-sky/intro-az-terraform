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
  vnet_rg = "deployment-05-${terraform.workspace}-rg"
}

resource "azurerm_resource_group" "rg" {  
  name     = local.vnet_rg
  location = var.location
}  
  
