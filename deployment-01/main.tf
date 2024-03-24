
locals {
  prefix = basename(abspath(path.module))
}

// Obtain the location from the deployment-00 module
module "deployment-00" {
    source = "../deployment-00"
}

// Create a resource group
resource "azurerm_resource_group" "rg" {  
  name     = "${local.prefix}-rg"
  location = module.deployment-00.location
}  

/* Create a virtual network 
but only after the network security group is created.
This is done by using the depends_on meta-argument to specify that the virtual network depends on the network security group.
*/
resource "azurerm_virtual_network" "vnet" {
  name                = "${local.prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.vnet.address_space]
  subnet {
    name = var.vnet.subnet_name
    address_prefix = var.vnet.address_space
    security_group = azurerm_network_security_group.nsg.id
  }
  depends_on = [ azurerm_network_security_group.nsg ]
}

// Create a network security group
resource "azurerm_network_security_group" "nsg" {
  name                = "${local.prefix}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
  name                        = "in_http"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

}

