data "azurerm_subnet" "example" {
  name                 = "default"
  virtual_network_name = "test-vnet"
  resource_group_name  = var.main.resource_group_name
}

output "subnet_id" {
  value = data.azurerm_subnet.example.id
}
