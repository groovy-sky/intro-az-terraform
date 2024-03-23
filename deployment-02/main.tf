provider "azurerm" {    
  features {}  
}

provider "random"{
}

provider "http" {
}

locals {
  location = "West Europe"
  prefix = "deployment-02"
}

resource "random_password" "vm_pass" {
  length           = 60
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

data "terraform_remote_state" "vnet" {  
  backend = "local"  
  config = {  
    path = "../deployment-01/terraform.tfstate"  
  }  
} 

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

data "http" "vm_http_check"{
    url = "http://${jsondecode(azurerm_resource_group_template_deployment.arm_vm.output_content).public_ip.value}"
}

output "http_response" {  
  value = data.http.vm_http_check.response_body  
}  