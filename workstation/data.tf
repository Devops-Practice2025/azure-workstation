data "azurerm_resource_group" "example" {
  name = "nebula-sandbox-karthikeyangopal-2a6a0756"
  location = "eastus"
}

data "azurerm_subnet" "example" {
  name                 = "default"
  virtual_network_name = "test-vnet"
  resource_group_name  = data.azurerm_resource_group.example.name
}
