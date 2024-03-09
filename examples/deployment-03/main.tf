provider "azurerm" {    
  features {}  
}

variable "resource_group_name" {  
  description = "The name of the resource group"  
  type        = string  
  default     = "deployment-03-rg"
}  
  
variable "location" {  
  description = "The location of the resource group"  
  type        = string  
  default     = "West Europe"  
}  

resource "azurerm_resource_group" "state_rg" {    
  name     = var.resource_group_name   
  location = var.location   
}   

resource "azurerm_resource_group_template_deployment" "arm-storage-deploy" {
  name                = "arm-storage-deploy"
  resource_group_name = var.resource_group_name

  template_content = file("template.json")
  deployment_mode = "Incremental"
  depends_on = [ azurerm_resource_group.state_rg ]
}

  
data "azurerm_storage_account" "sa" {    
  name                = jsondecode(azurerm_resource_group_template_deployment.arm-storage-deploy.output_content)["storageName"]["value"]  
  resource_group_name = azurerm_resource_group.state_rg.name    
}   
  
output "container_name" {    
  value = jsondecode(azurerm_resource_group_template_deployment.arm-storage-deploy.output_content)["containerName"]["value"]  
}   

output "storage_account_name" {
  value = data.azurerm_storage_account.sa.name
}
  
output "primary_access_key" {  
  value = "${data.azurerm_storage_account.sa.primary_access_key}"  
  sensitive = true  
}  
