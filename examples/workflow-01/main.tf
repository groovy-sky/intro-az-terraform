provider "azurerm" {    
  features {}  
}

locals {
    resource_group_location = "West Europe"    
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "workflow-01"
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  default    = ""
}

resource "azurerm_resource_group" "rg" {  
  name     = var.resource_group_name
  location = local.resource_group_location
}  

resource "azurerm_storage_account" "storage" {
name                     = var.storage_account_name != "" ? var.storage_account_name : "${substr(md5(azurerm_resource_group.rg.id),0,20)}"
resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

output "storage_id" {
  value = azurerm_storage_account.storage.id
}