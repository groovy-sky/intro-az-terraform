#!/bin/bash  
    
export ARM_ACCESS_KEY=$(terraform output -raw primary_access_key)  
  
STORAGE_ACCOUNT_NAME=$(terraform output -raw storage_account_name)  

export STORAGE_ACCOUNT_NAME=$STORAGE_ACCOUNT_NAME
  
cat > ../root.hcl << EOF  
remote_state {  
  generate = {
  path      = "backend.tf"
  if_exists = "overwrite"
  }
  backend = "azurerm" 
  config = {  
    storage_account_name  = "${STORAGE_ACCOUNT_NAME}"  
    container_name = "\${path_relative_to_include()}"  
    key            = "terraform.tfstate"  
  }  
} 
EOF

cat > ../global_vars.yaml << EOF  
remote_state_account: "${STORAGE_ACCOUNT_NAME}" 
remote_state_key: "terraform.tfstate" 
EOF

content=$(<terragrunt.hcl)  

for dir in ../deployment-0*/   
do  
  # Write the content to each terragrunt.hcl file in the deployment-0* directories  
  echo "$content" > "${dir}terragrunt.hcl"  
done  