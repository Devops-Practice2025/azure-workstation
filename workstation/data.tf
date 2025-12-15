data "azurerm_resource_group" "example" {
  name = "nebula-sandbox-karthikeyangopal-6fc2f68e"
}

data "azurerm_subnet" "example" {
  name                 = "default"
  virtual_network_name = "Sand-setup-network"
  resource_group_name  = data.azurerm_resource_group.example.name
}