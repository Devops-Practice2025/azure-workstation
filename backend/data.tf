# Data block to read an existing resource group
data "azurerm_resource_group" "rg" {
  name = "openenv-gk8zk-1"
     }


output "rg" {
  value = data.azurerm_resource_group.rg
  
}