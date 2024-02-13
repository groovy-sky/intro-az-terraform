# Introduction to Terraform in Azure  
  
This tutorial provides a quick introduction to using Terraform to manage infrastructure in Microsoft Azure.  
  
## Learning Plan  
  
1. Overview
2. Setting Up Terraform  
3. Writing a Basic Terraform Configuration File  
4. Deploying Resources in Azure with Terraform  
5. Managing Changes with Terraform  
6. Cleaning Up Resources  
  
## 1. Overview

Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp. It uses a declarative configuration language to define and provide data center infrastructure.
Infrastructure as Code (IaC)
 
Infrastructure as Code (IaC) is the process of managing and provisioning computing infrastructure with machine-readable definition files, rather than physical hardware configuration or interactive configuration tools.
Declarative Resource Deployment
 
In a declarative approach to infrastructure management, like the one Terraform uses, you only need to specify what you want your infrastructure to look like and Terraform will figure out how to achieve that state.
Terraform Workflow Stages
 
The Terraform workflow has the following stages:
* Write: You define resources, which may be across multiple cloud providers and services.
* Plan: Terraform creates an execution plan describing the infrastructure it will create, update, or destroy based on the existing infrastructure and your configuration.
* Apply: On approval, Terraform performs the proposed operations in the correct order, respecting any resource dependencies.

### Terraform Components

The main components of Terraform are:

* Terraform Core: The primary component that reads configuration files and manages resources.
* Terraform Providers/Plugins: Plugins for each cloud provider (like Azure, AWS, GCP) that implement resource types.
* Terraform CLI (Command Line Interface): The command line tool that interacts with Terraform Core and the Providers.

#### Terraform Core

Terraform Core is a statically-compiled binary written in the Go programming language. The compiled binary is the command line tool (CLI) terraform, the entrypoint for anyone using 
Terraform. The code source is available at github.com/hashicorp/terraform.

The primary responsibilities of Terraform Core are:

* Infrastructure as code: reading and interpolating configuration files and modules
* Resource state management
* Construction of the Resource Graph
* Plan execution
* Communication with plugins over RPC

#### Terraform Providers/Plugins

Terraform Plugins are written in Go and are executable binaries invoked by Terraform Core over RPC. Each plugin exposes an implementation for a specific service, such as AWS, or provisioner, such as bash. All Providers and Provisioners used in Terraform configurations are plugins. They are executed as a separate process and communicate with the main Terraform binary over an RPC interface. Terraform has several Provisioners built-in, while Providers are discovered dynamically as needed (See Discovery below). Terraform Core provides a high-level framework that abstracts away the details of plugin discovery and RPC communication so developers do not need to manage either.

Terraform Plugins are responsible for the domain specific implementation of their type.
The primary responsibilities of Provider Plugins are:

* Initialization of any included libraries used to make API calls
* Authentication with the Infrastructure Provider
* Define managed resources and data sources that map to specific services
* Define functions that enable or simplify computational logic for practitioner configurations

#### Terraform CLI

Terraform is operated via a command-line interface, and it has several different commands that allow you to interact with your infrastructure.
Main Commands:
```
    init: Prepare your working directory for other commands
    validate: Check whether the configuration is valid
    plan: Show changes required by the current configuration
    apply: Create or update infrastructure
    destroy: Destroy previously-created infrastructure
```
All Other Commands:
```
    console: Try Terraform expressions at an interactive command prompt
    fmt: Reformat your configuration in the standard style
    force-unlock: Release a stuck lock on the current workspace
    get: Install or upgrade remote Terraform modules
    graph: Generate a Graphviz graph of the steps in an operation
    import: Associate existing infrastructure with a Terraform resource
    login: Obtain and save credentials for a remote host
    logout: Remove locally-stored credentials for a remote host
    metadata: Access metadata related commands
    output: Show output values from your root module
    providers: Show the providers required for this configuration
    refresh: Update the state to match remote systems
    show: Show the current state or a saved plan
    state: Advanced state management
    taint: Mark a resource instance as not fully functional
    test: Execute integration tests for Terraform modules
    untaint: Remove the 'tainted' state from a resource instance
    version: Show the current Terraform version
    workspace: Workspace management
```

  
## 2. Terraform on Azure

Terraform plays well with Azure. It can manage a wide variety of Azure resources. To interact with the Azure services, Terraform uses the Azure provider plugin. This provider must be configured with valid Azure credentials before it can be used.

There are several Terraform providers that enable the management of Azure infrastructure:

- [AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs): Manage stable Azure resources and functionality such as virtual machines, storage accounts, and networking interfaces.
- [AzureAD](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs): Manage Microsoft Entra resources such as groups, users, service principals, and applications.
- [AzureDevops](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs): Manage Azure DevOps resources such as agents, repositories, projects, pipelines, and queries.
- [AzAPI](https://registry.terraform.io/providers/Azure/azapi/latest/docs): Manage Azure resources and functionality using the Azure Resource Manager APIs directly. This provider compliments the AzureRM provider by enabling the management of Azure resources that aren't released. For more information about the AzAPI provider, see [Terraform AzAPI provider](https://learn.microsoft.com/en-us/azure/developer/terraform/overview-azapi-provider).
- [AzureStack](https://registry.terraform.io/providers/hashicorp/azurestack/latest/docs): Manage Azure Stack Hub resources such as virtual machines, DNS, virtual networks, and storage.


## 3. 
  
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
