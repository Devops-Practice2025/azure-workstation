resource "azurerm_container_registry" "acr" {
  name                = "testaksregistry1234"
  resource_group_name = local.nebula_rg
  location            = local.nebula_location

  sku                 = "Standard"
  admin_enabled       = false
}
