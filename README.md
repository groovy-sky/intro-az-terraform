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
[4. Organizing Infrastructure](#)  


## Overview
  
Terraform, developed by HashiCorp, is Infrastructure as Code (IaC) tool that uses a declarative configuration language to define and provision data center infrastructure. It follows a declarative approach to infrastructure management, where you specify your desired infrastructure state, and Terraform figures out how to achieve it.  

The building blocks of Terraform are modules, input variables, local values, and output values. These can be compared to components of a function in a general purpose programming language.

* Modules: In Terraform, a module can be likened to a function. It encapsulates a piece of your infrastructure setup, like a server or a database, for reuse and organization. A module block can be seen as a call to a function.
Input Variables: Input variables in Terraform are like parameters to a function. You define an input variable and assign it a value inside a module block, similar to passing an argument to a function.
* Local Values: Local values in Terraform are akin to local variables within a function. They are values that are only visible and accessible within the module in which they are defined, providing a way to simplify complex expressions and group related values.
* Output Values: Output values are like named return values from a function. They allow you to export information about the resources in a module, so it can be easily accessed by other parts of your configuration or when running Terraform commands.

It's important to note that Terraform is a declarative language. This means that, unlike a function that performs actions, a module in Terraform describes the desired state of infrastructure resources. The actions required to achieve this desired state are determined by Terraform Core using the associated providers.
  
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

### Terraform Configuration Files

For this tutorial all the Terraform configuration files are stored under [examples](/examples/) folder of [this repository](https://github.com/groovy-sky/lazy-intro-az-terraform). To start use them just clone the repository and navigate to the examples folder.

```bash
git clone https://github.com/groovy-sky/lazy-intro-az-terraform.git
cd lazy-intro-az-terraform/examples
```
  
## First workflow

Terraform configuration files, written in a declarative language called HCL (HashiCorp Configuration Language), define your desired resources. [First workflow](/examples/workflow-00/main.tf) deploys "example-resource-group" resource group in "West Europe" region using the AzureRM provider:

```hcl  
provider "azurerm" {
  features {}
}
  
resource "azurerm_resource_group" "first_resource_group" {  
  name     = "example-resource-group"  
  location = "West Europe"  
}  
```

### Initialize the Working Directory

Initialize a working directory containing Terraform configuration file. 

To run this configuration, you need to initialize the working directory, create an execution plan, and apply the changes. Here's how you can do this using the Terraform CLI:

```bash
terraform init
```

This command initializes the working directory and downloads the AzureRM provider plugin:

![](/img/terraform_init.png)

### Create and Apply an Execution Plan

Terraform creates an execution plan describing the infrastructure it will create. After reviewing the plan, you can apply it to create the infrastructure. As first workflow is very simple, let's skip the plan creation and apply the changes directly:

```bash
terraform apply
```

![](/img/terraform_apply.png)

As you can see, before applying the changes, Terraform shows you the execution plan. If you are satisfied with the plan, you can approve it by typing yes. Terraform then applies the changes and creates the resource group.

### Destroy the Infrastructure

To clean up the resources created by Terraform, you can run the destroy command:

```bash
terraform destroy
```

![](/img/terraform_destroy.png)


## Organizing Infrastructure

When working with Terraform, it's crucial to keep your environment organized. This involves managing your configuration files, state files, and modules effectively.  
  
- **Configuration Files**: These are the files where you write your infrastructure code. It's a good practice to split your configuration into multiple files for better readability and maintainability.  Also you can use variables and outputs to make your configuration more flexible and reusable.
- **State Files**: Terraform creates a state file after applying a configuration. This file helps Terraform track the resources it has created. You should manage your state files carefully and consider using remote state storage for collaboration and security.  
- **Modules**: Modules are reusable, self-contained packages of Terraform configurations. Organizing your code into modules helps to keep your code DRY (Don't Repeat Yourself), making it more efficient and easier to manage.  

### Configuration Files

Code in the Terraform language is stored in plain text files with the .tf (and also .tf.json) file extension. These files contain the configuration for your infrastructure, including resources, providers, variables, and outputs.

Terraform normally loads all of the .tf and .tf.json files within a directory and expects each one to define a distinct set of configuration objects. If two files attempt to define the same object, Terraform returns an error.

There is no strict requirement for how to organize your configuration files, but it's a good practice to keep them organized and easy to understand. You can split your configuration into multiple files. 



In Terraform, a module is a container for multiple resources that are used together. Modules allow you to encapsulate a set of resources and operations into a reusable package. This can be used in different parts of your Terraform environment or even shared across multiple configurations.  
  
There are several benefits to using modules in Terraform:  
  
- **Reusability**: Create a module once and reuse it in multiple places. This reduces code duplication and improves consistency across your infrastructure.  
- **Organization**: Group related resources into modules to keep your code clean, organized, and easy to understand.  
- **Abstraction**: Hide the complexity of a set of resources by wrapping them into a module with defined inputs and outputs. This simplifies your configuration and makes it easier to manage.  
- **Versioning and Source Control**: Track changes over time and release new versions of a module in a controlled manner. Modules can be versioned and stored in a source control system, like Git.  


### Structuring Configuration Files

In previous section you learned how to create and run a simple Terraform workflow, which deploys an Azure resource group. Now, let's discuss how to organize your Terraform environment effectively.  
  
In order to structure your Terraform configuration you can break it down into multiple files and introduce variables for more flexibility. Here is how you could potentially refactor your environment:

First, define your provider in a separate file, say providers.tf:

```hcl
provider "azurerm" {    
  features {}  
}  
```

Next, create a new file named variables.tf to define variables that can be passed to the configuration:

```hcl
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
```

Then, refactor your main.tf to use these variables:

```hcl
resource "azurerm_resource_group" "first_resource_group" {    
  name     = var.resource_group_name   
  location = var.location   
}    
```
 
Finally, you can define outputs in a separate file, say outputs.tf. Since your current configuration doesn't have any outputs, this file is optional. However, for future use, you may have something like:

```hcl
output "resource_group_id" {  
  description = "The ID of the resource group"  
  value       = azurerm_resource_group.first_resource_group.id  
}  
```
 
This way, your code is structured more neatly, is easier to maintain, and allows for more flexibility and reusability.  

### Structuring Environment

For a better organization, you can also split your configuration into multiple environments. For example, you can have a development environment and a production environment. This way, you can manage different environments separately and keep your codebase clean and organized.

```
├── dev  
│   ├── main.tf  
│   ├── variables.tf  
│   ├── outputs.tf  
├── prod  
│   ├── main.tf  
│   ├── variables.tf  
│   ├── outputs.tf  
├── variables.tf  
├── outputs.tf  
└── providers.tf  
```

As you can see, each environment has its own main.tf, variables.tf, and outputs.tf files. The root level contains the shared variables and outputs, as well as the provider configuration. This structure allows you to manage different environments separately and keep your codebase clean and organized.


  
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

```
# Add this to your .bashrc file  

# Search for the .terraform/environment file and display the current workspace.
# Can be overridden by setting the TF_WORKSPACE environment variable.
tf_workspace() {    
    if [ -n "$TF_WORKSPACE" ] && [ -d ".terraform" ] && [ -f ".terraform/environment" ]; then  
        echo -e "[TF_WORKSPACE=\033[32m$TF_WORKSPACE\033[0m]"    
    elif [ -d ".terraform" ] && [ -f ".terraform/environment" ]; then    
        echo -e "[\033[32m$(cat .terraform/environment)\033[0m]"    
    fi    
}    

# Add the Terraform workspace to Shell prompt 
export PS1="\u@\h \w \$(tf_workspace)$ "

```

```
cat << EOF >> ~/.bashrc  
  
# Function to get the current Terraform workspace  
tf_workspace() {  
    if [ -d ".terraform" ] && [ -f ".terraform/environment" ]; then  
        echo -e "[\033[32m\$(cat .terraform/environment)\033[0m]"  
    else  
        echo ""  
    fi  
}  
  
# Modify the PS1 variable to include the Terraform workspace  
export PS1="\u@\h \w \$(tf_workspace)$ "  
  
EOF  
```

```
 x  
```

## Additional Resources  
  
- [Terraform on Azure](https://developer.hashicorp.com/terraform/tutorials/azure-get-started)  
- [Terraform Azure Course](https://github.com/in4it/terraform-azure-course/blob/master/for-foreach/instance.tf)  
- [Getting started with Terraform on Azure Cloud Shell](https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash)  
- [Terraform Provider for Azure (Resource Manager)](https://github.com/hashicorp/terraform-provider-azurerm/blob/main/examples/web/static-site/main.tf)
- [Terraform and Terragrunt guidlines](https://github.com/padok-team/docs-terraform-guidelines/blob/main/README.md)
- [ARM deployment with Terraform](https://github.com/geekzter/repro-repo/blob/master/terraform/azurerm_resource_group_template_deployment/main.tf)
- https://developer.hashicorp.com/terraform/tutorials/modules/pattern-module-creation
- https://github.com/cobbler/cobbler/blob/main/docs/user-guide/terraform-provider.rst
* https://www.pluralsight.com/resources/blog/cloud/the-ultimate-terraform-cheatsheet
* https://spacelift.io/blog/terraform-environments
* https://xebia.com/blog/how-to-use-terraform-workspaces-to-manage-environment-based-configuration-2/
* https://www.hashicorp.com/blog/structuring-hashicorp-terraform-configuration-for-production
* https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices/part1#one-workspace-per-environment-per-terraform-configuration
* https://developer.hashicorp.com/terraform/language/settings/backends/configuration
* https://github.com/hashicorp/learn-terraform-state
* https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
* https://blog.gruntwork.io/how-to-manage-multiple-environments-with-terraform-32c7bc5d692
* https://github.com/cloudsecuritylabs/terraform-learning/wiki
* https://support.hashicorp.com/hc/en-us/articles/360043550953-Selecting-a-workspace-when-running-Terraform-in-automation