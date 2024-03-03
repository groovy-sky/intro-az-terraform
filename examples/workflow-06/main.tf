resource "azurerm_resource_group" "first_resource_group" {    
  name     = var.resource_group_name   
  location = var.location   
}   

resource "azurerm_resource_group_template_deployment" "arm-storage-deploy" {
  name                = "arm-storage-deploy"
  resource_group_name = var.resource_group_name

  template_content = file("template.json")
  deployment_mode = "Incremental"
  depends_on = [ azurerm_resource_group.first_resource_group ]
}