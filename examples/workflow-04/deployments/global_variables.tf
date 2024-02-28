# Global variables

variable "az_core_network_rg" {  
  type = map(string) 
  default = {
    "prod": "rg-az-core-network-prod", "dev": "rg-az-core-network-dev"
  }
}

variable "az_core_network_location" {  
  type        = string  
  default = "westeurope"
}

variable "az_core_network_vnet_name" {  
  type        = map(string)
  default = {
    "prod": "vnet-az-core-network-prod", "dev": "vnet-az-core-network-dev"
  }
}

variable "az_core_network_vnet_address_space" {  
  type        = map(string)  
  default = {"prod": "192.168.0.0/16", "dev": "10.0.0.0/16"}
}
