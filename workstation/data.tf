data "azurerm_resource_group" "example" {
  name = "nebula-sandbox-karthikeyangopal-2a6a0756"
}

data "azurerm_subnet" "example" {
  name                 = "default"
  virtual_network_name = "Sand-setup-network"
  resource_group_name  = data.azurerm_resource_group.example.name
}
