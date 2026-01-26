# Data block to read an existing resource group
data "azurerm_resource_group" "nebula" {
     name_prefix = "nebula"
}
locals {
  nebula_rg = data.azurerm_resource_group.nebula.name[0]
 nebula_location = data.azurerm_resource_group.nebula.location[0]
}

output "rg" {
  value = local.nebula_rg.name
  
}
output "location" {
    value = local.nebula_location
  
}