include {    
  path = find_in_parent_folders()    
}

# Reads values from global_vars.yaml
locals {
  vars = yamldecode(file(find_in_parent_folders("global_vars.yaml", "global_vars.yaml")))
}

# Set inputs from definitions in global_vars.yaml 
inputs = local.vars
