terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.113" # or latest available in your environment
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    use_cli              = true                                    # Can also be set via `ARM_USE_CLI` environment variable.
    use_azuread_auth     = true                                    # Can also be set via `ARM_USE_AZUREAD` environment variable.
    storage_account_name = "store202602"                              # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "dev.terraform.tfstate"                # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }

}
# Access an existing Key Vault
data "azurerm_key_vault" "vault" {
  name                = "test-kv-2026011"
  resource_group_name = "openenv-rrv2r-1"
}

# Fetch the secret
data "azurerm_key_vault_secret" "sp_secret" {
  name         = "client-secret"
  key_vault_id = data.azurerm_key_vault.vault.id
}
provider "azurerm" {
  features {}
}
# Assign the secret to your provider
provider "azurerm" {
   alias           = "main"
  features {}
  subscription_id = var.subscription_id 
  client_id     = var.client_id
  client_secret = data.azurerm_key_vault_secret.sp_secret.value
  tenant_id     = var.tenant_id
}

