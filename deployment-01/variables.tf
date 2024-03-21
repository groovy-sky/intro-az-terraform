variable "vnet" {
  type = map(string)
  default = {
    address_space = "10.0.1.0/24"
    subnet_name = "default"
  }
}