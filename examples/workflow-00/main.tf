provider "azurerm" {    
  features {}  
}

variable "resource_group_name" {  
  description = "The name of the resource group"  
  type        = string  
  default     = "terraform-resource-group"  
}  
  
variable "location" {  
  description = "The location of the resource group"  
  type        = string  
  default     = "West Europe"  
}  

resource "azurerm_resource_group" "example" {  
  name     = var.resource_group_name  
  location = var.location  
}  
