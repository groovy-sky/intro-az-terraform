# Getting Started with Terraform on Azure  
  
This tutorial offers a quick introduction to using Terraform, an open-source Infrastructure as Code (IaC) tool, for managing infrastructure in Microsoft Azure.  
  
## Learning Objectives  
  
- Understand what Terraform is and its main components.  
- Learn how to use Terraform on Azure.  
- Install Terraform on your local machine.  
- Create and deploy resources in Azure using Terraform.  
  
## 1. How Terraform 
  
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
  
## 2. Using Terraform on Azure  
  
Terraform works seamlessly with Azure, managing a wide range of Azure resources. To interact with Azure services, Terraform uses the Azure provider plugin, which needs to be configured with valid Azure credentials.  
  
There are several Terraform providers for managing Azure infrastructure, including [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs), [AzureAD](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs), and [AzAPI](https://registry.terraform.io/providers/Azure/azapi/latest/docs).  
  
## 3. Installing Terraform  
  
To use Terraform, first, install it on your local machine. Download Terraform from the [official website](https://www.terraform.io/downloads.html) and follow the [installation instructions](https://learn.hashicorp.com/tutorials/terraform/install-cli) for your specific operating system.    
  
## 4. Creating Your First Terraform Configuration  
  
Terraform configuration files, written in a declarative language called HCL (HashiCorp Configuration Language), define your desired resources. Here's an example configuration file that creates an Azure Resource Group:    
  
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
## 5. Deploying Azure Resources with Terraform  
  
After preparing your configuration file, initialize your Terraform working directory with `terraform init`, review the planned changes with `terraform plan`, and apply the changes to create resources in Azure with `terraform apply`.  

## 6. Organizing Your Terraform Environment  
  
When working with Terraform, it's crucial to keep your environment organized. This involves managing your configuration files, state files, and modules effectively.  
  
- **Configuration Files**: These are the files where you write your infrastructure code. It's a good practice to split your configuration into multiple files for better readability and maintainability.  
- **State Files**: Terraform creates a state file after applying a configuration. This file helps Terraform track the resources it has created. You should manage your state files carefully and consider using remote state storage for collaboration and security.  
- **Modules**: Modules are reusable, self-contained packages of Terraform configurations. Organizing your code into modules helps to keep your code DRY (Don't Repeat Yourself), making it more efficient and easier to manage.  
  
## 7. Creating Workflow Files using AzAPI and AzureRM  
  
You can use both AzAPI and AzureRM providers in your workflow files, depending on your needs. Here are two examples:  
  
### Example Using AzureRM Provider  
  
```hcl  
provider "azurerm" {  
  version = "=2.40.0"  
  features {}  
}  
  
resource "azurerm_resource_group" "rg" {  
  name     = "example-resources"  
  location = "West Europe"  
}  
```

### Example Using AzAPI Provider
```hc1
provider "azapi" {  
  version = "=0.1.0"  
}  
  
resource "azapi_virtual_network" "vnet" {  
  name                = "example-vnet"  
  resource_group_name = azurerm_resource_group.rg.name  
  location            = azurerm_resource_group.rg.location  
  address_space       = ["10.0.0.0/16"]  
}  
```
  
Remember, using both providers might need additional setup for authenticating each one. Also, the AzAPI provider requires a deeper understanding of Azure's REST APIs, so it's recommended for advanced use-cases.  

## 8. Organizing Infrastructure with Terraform Modules  
  
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
