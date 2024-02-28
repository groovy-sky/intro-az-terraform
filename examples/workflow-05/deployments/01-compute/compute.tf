provider "azurerm" {  
  features {}  
}  

locals {
  tags =  tomap({
    "environment": terraform.workspace
    }
  )
  vm_rg = "${var.vm_name[terraform.workspace]}-rg"
  vm_nsg = "${var.vm_name[terraform.workspace]}-nsg"
  vm_nic = "${var.vm_name[terraform.workspace]}-nic"
}


# Obtain Public IP address of code deployment machine

data "http" "this" {
  url   = "https://ifconfig.me/ip"
}

module "vm_nsg" {
  source = "../../modules/nsg_allow_in_ip"
  nsg_name = local.vm_nsg
  location = var.location
  rg = local.vm_rg
  tags = local.tags
  rule_destination_port = "22"
  rule_priority = 100
  rule_name = "allow_ssh"
  source_ip = data.http.this.response_body
  depends_on = [ azurerm_resource_group.rg ]
}

resource "azurerm_resource_group" "rg" {  
  name     = local.vm_rg
  location = var.location
}  
