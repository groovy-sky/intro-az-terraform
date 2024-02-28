variable "location" {  
  description = "The location where all resources should be created"  
  type        = string  
  default     = "West Europe"  
}  

variable "vm_name" {  
  type        = map(string)
}

variable "vm_size" {  
  type        = map(string)
}