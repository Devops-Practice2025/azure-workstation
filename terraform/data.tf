# Data block to read an existing resource group
data "azurerm_resource_group" "nebula" {
     name = "nebula-sandbox-karthikeyangopal-629394fa"
}
locals {
  nebula_rg = data.azurerm_resource_group.nebula.name
 nebula_location = data.azurerm_resource_group.nebula.location
}

output "rg" {
  value = local.nebula_rg
  
}
output "location" {
    value = local.nebula_location
  
}