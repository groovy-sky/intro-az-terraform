output "subnet_id" {
  value = "${azurerm_virtual_network.vnet.id}/subnets/${var.vnet.subnet_name}"
}
