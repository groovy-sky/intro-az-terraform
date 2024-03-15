remote_state {  
  generate = {
  path      = "backend.tf"
  if_exists = "overwrite"
  }
  backend = "azurerm" 
  config = {  
    storage_account_name  = "zy2gbs3nvhj3i"  
    container_name = "${path_relative_to_include()}"  
    key            = "terraform.tfstate"  
  }  
}  
