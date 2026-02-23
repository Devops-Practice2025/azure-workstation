resource "random_string" "suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tf${random_string.suffix.result}state"
  resource_group_name      = data.azurerm_resource_group.rg
  location                 = "westuk"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  lifecycle { prevent_destroy = true }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
  lifecycle { prevent_destroy = true }
}

output "backend_storage_account" {
  value = azurerm_storage_account.tfstate.name
}
output "backend_container" {
  value = azurerm_storage_container.tfstate.name
}

