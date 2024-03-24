provider "azurerm" {    
  features {}  
}

provider "random"{
}

provider "http" {
}

locals {
  location = "West Europe"
  prefix = basename(abspath(path.module))
}

// Generate a random password for the VM
resource "random_password" "vm_pass" {
  length           = 60
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

// Obtain state from the deployment-01 module
data "terraform_remote_state" "vnet" {  
  backend = "local"  
  config = {  
    path = "../deployment-01/terraform.tfstate"  
  }  
} 

/*
Create a resource group using an ARM template.
Input parameters are passed to the ARM template in JSON format by encoding the parameters using the jsonencode function.
*/
resource "azurerm_subscription_template_deployment" "arm_rg" {
  name             = "${local.prefix}-rg"
  location         = local.location
  parameters_content = jsonencode({
    "prefix" = {
      value = local.prefix
    },
    "rgLocation" = {
      value = local.location
    }
  })
  template_content = file("rg.json")
}

// Create a VM from vm.json ARM template
resource "azurerm_resource_group_template_deployment" "arm_vm" {
    name                = "${local.prefix}-vm"
    deployment_mode     = "Incremental"
    resource_group_name = jsondecode(azurerm_subscription_template_deployment.arm_rg.output_content).rgName.value
    template_content = file("vm.json")
    parameters_content = jsonencode ({
      "vmName" = {
        value = "${local.prefix}-vm"
      },
      "location" = {
        value = local.location
      },
      "vmSize" = {
        value = "Standard_DS1_v2"
      },
      "adminUsername" = {
        value = "adm1nuser"
      },
      "adminPassword" = {
        value = random_password.vm_pass.result
      },
      "subnetId" = {
        value = data.terraform_remote_state.vnet.outputs.subnet_id
      }
})
}

/* After VM is created, check that NGINX was installed and configured using an HTTP check.
The URL for the check is the public IP address of the VM, which is allowed by NSG for port 80.
*/
data "http" "vm_http_check"{
    url = "http://${jsondecode(azurerm_resource_group_template_deployment.arm_vm.output_content).public_ip.value}"
}

// Output the HTTP response
output "http_response" {  
  value = data.http.vm_http_check.response_body  
}  