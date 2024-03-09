terraform {  
  backend "azurerm" {  
    storage_account_name  = "zy2gbs3nvhj3i"  
    container_name        = "tfstate"  
    key                   = "terraform.tfstate"
  }  
}  
