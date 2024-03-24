provider "azurerm" {  
  features {}  
}  

provider "random" {  
}  

variable "location" {  
  description = "The location where all resources should be created"  
  type        = string  
  default     = "West Europe"  
}  

variable "vm_size" {  
  description = "The size of the virtual machine"  
  type        = map(string) 
} 

resource "random_password" "vm_pass" {
  length           = 60
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  tags =  tomap({
    "environment": terraform.workspace
    }
  )
  prefix = "${basename(abspath(path.module))}-${terraform.workspace}"
  global_vars = yamldecode(file("../global_vars.yaml")) // Load global_vars.yaml file
}

// Create a resource group
resource "azurerm_resource_group" "rg" {  
  name     = "${local.prefix}-rg"
  location = var.location
}  

// Obtain the default subnet ID from the remote state in current workspace
data "terraform_remote_state" "deployment-04" {  
  backend = "azurerm"  
  config = {  
    container_name = "deployment-04"  
    storage_account_name = local.global_vars.remote_state_account
    key            = "${local.global_vars.remote_state_key}env:${terraform.workspace}"
  }  
}

// Create a network interface
resource "azurerm_network_interface" "nic" {
  name                = "${local.prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = data.terraform_remote_state.deployment-04.outputs.default_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = local.tags
}

// Create a virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "${local.prefix}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size["${terraform.workspace}"]

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = random_password.vm_pass.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = local.tags
}