variable "resource_group_name" {  
  description = "The name of the resource group"  
  type = map(string) 
}  
  
variable "location" {  
  description = "The location of the resource group"  
  type        = string  
  default     = "West Europe"  
}  

variable "remote_storage_account_name" {  
  description = "The name of the remote storage account for the backend"  
  type        = map(string)  
}