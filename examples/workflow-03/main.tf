resource "azurerm_resource_group" "first_resource_group" {    
  name     = var.resource_group_name[terraform.workspace]
  location = var.location   
}   