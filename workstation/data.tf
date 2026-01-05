data "azurerm_subnet" "example" {
  name                 = "default"
  virtual_network_name = "test-vnet"
  resource_group_name = "nebula-sandbox-karthikeyangopal-2a6a0756"
}

output "subnet_id" {
  value = data.azurerm_subnet.example.id
}
