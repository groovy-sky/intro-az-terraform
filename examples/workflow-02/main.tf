resource "random_pet" "stroage_name" {
  length = 3
  separator = ""
}


module "storage_deploy" {
    source = "../workflow-01"
    storage_account_name = substr(random_pet.stroage_name.id,0,20)
    resource_group_name = "random-pet-rg"
}