terragrunt = {  
  include {
  path = find_in_parent_folders()
}
  terraform {  
    source = "/path/to/terraform/module"  
  }  
  
  terraform {  
    extra_arguments "custom_vars" {  
      commands = get_terraform_commands_that_need_vars()  
  
      optional_var_files = [  
        "${get_terragrunt_dir()}/terraform.tfvars"  
      ]  
    }  
  }  
}  