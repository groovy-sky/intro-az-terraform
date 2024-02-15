# Getting Started with Terraform on Azure  
  
This tutorial offers a quick introduction to using Terraform, an open-source Infrastructure as Code (IaC) tool, for managing infrastructure in Microsoft Azure.  
  
## Learning Objectives  
  
- Understand what Terraform is and its main components.  
- Learn how to use Terraform on Azure.  
- Install Terraform on your local machine.  
- Create and deploy resources in Azure using Terraform.  
  
# Table of Contents  
  
[1. Overview](#overview)  
[2. Prerequisites](#prerequisites)  
[3. First workflow](#first-workflow)  
 [Terraform Modules](#terraform-modules)  
 [Terraform Registry](#terraform-registry)  
 [Terraform and Azure Example](#terraform-and-azure-example)  
 [Conclusion](#conclusion)  

## Overview
  
Terraform, developed by HashiCorp, is an IaC tool that uses a declarative configuration language to define and provision data center infrastructure. It follows a declarative approach to infrastructure management, where you specify your desired infrastructure state, and Terraform figures out how to achieve it.  
  
### Terraform Workflow Stages  
  
The Terraform workflow includes the following stages:  
  
- **Write**: Define resources across multiple cloud providers and services.  
- **Plan**: Terraform creates an execution plan describing the infrastructure it will create, update, or destroy.  
- **Apply**: Upon approval, Terraform executes the proposed operations, respecting any resource dependencies.  
  
### Terraform Components  
  
Terraform primarily consists of:  
  
- **Terraform Core**: Reads configuration files and manages resources.  
- **Terraform Providers/Plugins**: Implement resource types for each cloud provider (like Azure, AWS, GCP).  
- **Terraform CLI (Command Line Interface)**: A command-line tool that interacts with Terraform Core and the Providers.  
  
### Azure and Terraform
  
Terraform works seamlessly with Azure, managing a wide range of Azure resources. To interact with Azure services, Terraform uses the Azure provider plugin, which needs to be configured with valid Azure credentials.  
  
There are several Terraform providers for managing Azure infrastructure, including [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs), [AzureAD](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs), and [AzAPI](https://registry.terraform.io/providers/Azure/azapi/latest/docs).  

In this tutorial AzureRM and AzAPI providers will be used to demonstrate how to create and manage Azure resources with Terraform.

## Prerequisites

To follow this tutorial, you'll need the following:
* An Azure account with an active subscription. If you don't have an account, you can create [a free account](https://azure.microsoft.com/en-us/free).
* Installed Terraform. For running this tutorial [Azure Cloud Shell](https://learn.microsoft.com/en-us/azure/cloud-shell/get-started/new-storage) should be enough. If you want to install Terraform on your local machine, you can download it from the [official website](https://www.terraform.io/downloads.html). 
  

### Credentials and Authentication

Before you can start using Terraform with Azure, you need to authenticate with Azure. Terraform supports several methods for authenticating with Azure, including using the Azure CLI, a Service Principal, or Managed Service Identity (MSI). More about that you can find [here](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure). If you are using Azure Cloud Shell, you can use the Azure CLI to authenticate with Azure.

  
## First workflow

In this tutorial, you will create a Terraform configuration to deploy an Azure resource group. 

Terraform configuration files, written in a declarative language called HCL (HashiCorp Configuration Language), define your desired resources. As a first step, you'll create a simple Terraform workflow, which deploys an Azure resource group using the AzureRM provider:

```hcl  
provider "azurerm" {  
  features {}
}  
  
resource "azurerm_resource_group" "first_resource_group" {  
  name     = "example-resource-group"  
  location = "West Europe"  
}  
```
  

### Resource Configuration

In previous section you learned how to create and run a simple Terraform workflow, which deploys an Azure resource group. Now, let's discuss how to organize your Terraform environment effectively.  
  
In order to structure your Terraform configuration you can break it down into multiple files and introduce variables for more flexibility. Here is how you could potentially refactor your environment:

First, define your provider in a separate file, say providers.tf:

provider "azurerm" {    
  features {}  
}  

Next, create a new file named variables.tf to define variables that can be passed to the configuration:

variable "resource_group_name" {  
  description = "The name of the resource group"  
  type        = string  
  default     = "example-resource-group"  
}  
  
variable "location" {  
  description = "The location of the resource group"  
  type        = string  
  default     = "West Europe"  
}  
 
Then, refactor your main.tf to use these variables:

resource "azurerm_resource_group" "first_resource_group" {    
  name     = var.resource_group_name   
  location = var.location   
}    

 
Finally, you can define outputs in a separate file, say outputs.tf. Since your current configuration doesn't have any outputs, this file is optional. However, for future use, you may have something like:

output "resource_group_id" {  
  description = "The ID of the resource group"  
  value       = azurerm_resource_group.first_resource_group.id  
}  

 
This way, your code is structured more neatly, is easier to maintain, and allows for more flexibility and reusability.  

### Organizing Infrastructure with Terraform Modules  

When working with Terraform, it's crucial to keep your environment organized. This involves managing your configuration files, state files, and modules effectively.  
  
- **Configuration Files**: These are the files where you write your infrastructure code. It's a good practice to split your configuration into multiple files for better readability and maintainability.  
- **State Files**: Terraform creates a state file after applying a configuration. This file helps Terraform track the resources it has created. You should manage your state files carefully and consider using remote state storage for collaboration and security.  
- **Modules**: Modules are reusable, self-contained packages of Terraform configurations. Organizing your code into modules helps to keep your code DRY (Don't Repeat Yourself), making it more efficient and easier to manage.  
  
In Terraform, a module is a container for multiple resources that are used together. Modules allow you to encapsulate a set of resources and operations into a reusable package. This can be used in different parts of your Terraform environment or even shared across multiple configurations.  
  
There are several benefits to using modules in Terraform:  
  
- **Reusability**: Create a module once and reuse it in multiple places. This reduces code duplication and improves consistency across your infrastructure.  
- **Organization**: Group related resources into modules to keep your code clean, organized, and easy to understand.  
- **Abstraction**: Hide the complexity of a set of resources by wrapping them into a module with defined inputs and outputs. This simplifies your configuration and makes it easier to manage.  
- **Versioning and Source Control**: Track changes over time and release new versions of a module in a controlled manner. Modules can be versioned and stored in a source control system, like Git.  
  
Here's an example of a module that creates an Azure virtual network:  
  
The module code (in `modules/network/main.tf`):  
  
```hcl  
variable "name" {}  
variable "location" {}  
variable "resource_group_name" {}  
variable "address_space" {}  
  
resource "azurerm_virtual_network" "vnet" {  
  name                = var.name  
  location            = var.location  
  resource_group_name = var.resource_group_name  
  address_space       = var.address_space  
}  
```

And here's how you would call this module from your main configuration:
```
module "network" {  
  source = "./modules/network"  
    
  name                = "example-network"  
  location            = "West Europe"  
  resource_group_name = "example-resource-group"  
  address_space       = ["10.0.0.0/16"]  
}  
```
In this example, the network module creates a virtual network in Azure. The module takes four variables as input: name, location, resource_group_name, and address_space. The main configuration calls this module and passes the values for these variables. The source argument points to the location of the module code.

Module use is highly recommended for larger Terraform configurations and collaborative projects, as it promotes code reuse and separation of concerns.

  
This section provides a brief overview of Terraform modules, their benefits, and how to use them. The included example demonstrates creating a module for an Azure virtual network and how to call this module from a main configuration.

## Additional Resources  
  
- [Terraform on Azure](https://developer.hashicorp.com/terraform/tutorials/azure-get-started)  
- [Terraform Azure Course](https://github.com/in4it/terraform-azure-course/blob/master/for-foreach/instance.tf)  
- [Getting started with Terraform on Azure Cloud Shell](https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash)  
- [Terraform Provider for Azure (Resource Manager)](https://github.com/hashicorp/terraform-provider-azurerm/blob/main/examples/web/static-site/main.tf)
- https://developer.hashicorp.com/terraform/tutorials/modules/pattern-module-creation
