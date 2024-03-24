provider "azurerm" {    
  features {}  
}

variable "resource_group_name" {  
  description = "The name of the resource group"  
  type        = string  
  default     = basename(abspath(path.module))
}  
  
variable "location" {  
  description = "The location of the resource group"  
  type        = string  
  default     = "West Europe"  
}  

// Create a resource group
resource "azurerm_resource_group" "state_rg" {    
  name     = var.resource_group_name   
  location = var.location   
}   

/* Deploys the ARM template which creates unique storage account name
based on tenant ID and subscription ID */
resource "azurerm_resource_group_template_deployment" "arm-storage-deploy" {
  name                = "arm-storage-deploy"
  resource_group_name = var.resource_group_name
  template_content = file("template.json")
  deployment_mode = "Incremental"
  depends_on = [ azurerm_resource_group.state_rg ]
}

// Get the storage account name and container name from the ARM template output
data "azurerm_storage_account" "sa" {    
  name                = jsondecode(azurerm_resource_group_template_deployment.arm-storage-deploy.output_content)["storageName"]["value"]  
  resource_group_name = azurerm_resource_group.state_rg.name    
}   

/* Following code block is used to list all directories in the parent directory 
which will be used to create storage containers in the storage account */
locals {  
  parent_directory = "../" // adjust this to point to your parent directory  
  directories_with_main_tf = fileset(local.parent_directory, "**/main.tf") // lists all directories in the parent directory  
  directories_list = [for d in local.directories_with_main_tf : replace(d, "/main.tf", "")] // removes the /main.tf suffix
}

// Create a storage container for each element in the directories_list
resource "azurerm_storage_container" "example" {  
  count                 = length(local.directories_list)  
  name                  = local.directories_list[count.index]  
  storage_account_name  = data.azurerm_storage_account.sa.name
  container_access_type = "private"  
}  

// Output the storage account name
output "storage_account_name" {
  value = data.azurerm_storage_account.sa.name
}
  
// Output the storage account primary access key
output "primary_access_key" {  
  value = "${data.azurerm_storage_account.sa.primary_access_key}"  
  sensitive = true  
}  
