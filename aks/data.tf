data "azurerm_resource_groups" "aks-rg" {

}

locals {
  # 2. Filter the list using a for loop and regex
  # This matches names starting with 'openenv' OR 'nebula'
  filtered_groups = [
    for rg in data.azurerm_resource_groups.aks-rg.resource_groups : rg.name 
    if can(regex("^(openenv|nebula)", rg.name))
  ]
}

# Output the results
output "target_resource_groups" {
  value = local.filtered_groups
}