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

  # Use remote backend if you have an Azure Storage account.
  # Replace with your storage details or manage via pipeline variables.
  backend "azurerm" {
    resource_group_name  = var.tfstate_resource_group
    storage_account_name = var.tfstate_storage_account
    container_name       = var.tfstate_container
    key                  = "aks/test-cluster.tfstate"
  }
}

provider "azurerm" {
  features {}
}