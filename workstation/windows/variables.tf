variable "location" {
  default = "southindia"
}

variable "vm_admin_username" {
  default = "azureuser"
}

variable "vm_admin_password" {
  description = "Windows admin password"
  sensitive   = true
}

output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}