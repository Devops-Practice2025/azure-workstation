data "azurerm_key_vault" "vault" {
  name                = "test-kv-2026011"
  resresource_group_name = "openenv-rrv2r-1"
}

# Fetch the secret
data "azurerm_key_vault_secret" "sp_secret" {
  name         = "client-secret"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_resource_group" "aks_rg" {
  name = "openenv-rrv2r-1"
}

