variable "nsg_name" {
  type        = string  
}

variable "location" {
  type        = string  
}

variable "rg" {
  type        = string  
}

variable "rule_name" {
  type        = string  
}

variable "rule_destination_port" {
  type        = string  
}

variable "rule_priority" {
  type = number
}

variable "source_ip" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {
  }
}


resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.rg

  security_rule {
    name                       = var.rule_name
    priority                   = var.rule_priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.rule_destination_port
    source_address_prefix      = var.source_ip
    destination_address_prefix = "*"
  }

  tags = var.tags
}

output "id" {
  value = azurerm_network_security_group.nsg.id
}
