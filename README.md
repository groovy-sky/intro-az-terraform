# Introduction to Terraform in Azure  
  
This tutorial provides a quick introduction to using Terraform to manage infrastructure in Microsoft Azure.  
  
## Learning Plan  
  
1. Introduction to Terraform  
2. Setting Up Terraform  
3. Writing a Basic Terraform Configuration File  
4. Deploying Resources in Azure with Terraform  
5. Managing Changes with Terraform  
6. Cleaning Up Resources  
  
## 1. Introduction to Terraform  
  
Terraform is an open-source Infrastructure as Code (IaC) tool created by HashiCorp. It allows you to define and provision datacenter infrastructure using a declarative configuration language. Terraform supports a multitude of cloud service providers, including Microsoft Azure.  
  
## 2. Setting Up Terraform  
  
Before you can use Terraform, you need to install it on your local machine. You can download Terraform from the [official website](https://www.terraform.io/downloads.html) and follow the [installation instructions](https://learn.hashicorp.com/tutorials/terraform/install-cli) for your specific operating system.  
  
## 3. Writing a Basic Terraform Configuration File  
  
A Terraform configuration file defines what resources you want. You write it in a declarative language called HCL (HashiCorp Configuration Language). Here's an example of how a simple configuration file that creates an Azure Resource Group may look like:  
  
```hcl  
provider "azurerm" {  
  version = "~>2.0"  
  features {}  
}  
  
resource "azurerm_resource_group" "example" {  
  name     = "example-resources"  
  location = "West Europe"  
}  
```
## 4. Deploying Resources in Azure with Terraform

 
Once you have your configuration file ready, you can use the terraform init command to initialize your Terraform working directory. Then, you can use the terraform plan command to see what changes Terraform will apply. Finally, you can use the terraform apply command to apply the changes and create the resources in Azure.
## 5. Managing Changes with Terraform

 
If you need to change your resources, you just need to update your Terraform configuration file and run terraform plan to see the changes that will be applied and terraform apply to apply the changes.
## 6. Cleaning Up Resources

 
When you no longer need the resources, you can use the terraform destroy command to remove all resources created by your Terraform configuration.

Note: Be sure to double-check what resources will be destroyed before running this command to avoid accidentally deleting important resources.

  
This tutorial just scratches the surface of what you can do with Terraform in Azure. I recommend checking out the [official Terraform documentation](https://www.terraform.io/docs/index.html) and [Azure provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) for more detailed information and examples.  

## Materials

https://developer.hashicorp.com/terraform/tutorials/azure-get-started
https://github.com/HoussemDellai/terraform-course/tree/main/14_arm_templates
https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash
