resource "random_pet" "random_value" {
  length = 3
  separator = ""
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "workflow-02"
}

module "storage_deploy" {
    source = "../workflow-01"
    storage_account_name = substr(random_pet.random_value.id,0,20)
    resource_group_name = var.resource_group_name
}