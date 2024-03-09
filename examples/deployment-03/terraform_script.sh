#!/bin/bash  
    
export ARM_ACCESS_KEY=$(terraform output -raw primary_access_key)  
  
STORAGE_ACCOUNT_NAME=$(terraform output -raw storage_account_name)  
CONTAINER_NAME=$(terraform output -raw container_name)  

export STORAGE_ACCOUNT_NAME=$STORAGE_ACCOUNT_NAME
  
cat > ../backend.tf << EOF  
terraform {  
  backend "azurerm" {  
    storage_account_name  = "${STORAGE_ACCOUNT_NAME}"  
    container_name        = "${CONTAINER_NAME}"  
    key                   = "terraform.tfstate"
  }  
}  
EOF