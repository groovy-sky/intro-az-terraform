variable "resource_group_name" {  
  description = "The name of the resource group"  
  type = map(string) 
}  
  
variable "location" {  
  description = "The location of the resource group"  
  type        = string  
  default     = "West Europe"  
}  
