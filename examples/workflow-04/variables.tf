variable "location" {  
  description = "The location where all resources should be created"  
  type        = string  
  default     = "West Europe"  
}  

variable "vnet_address_space" {  
  type        = map(string)  
}

variable "vnet_subnet_name" {  
  type        = string
  default = "default"
}
