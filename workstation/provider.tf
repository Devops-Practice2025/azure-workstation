provider "azurerm" {
  features {}
  subscription_id = "5556f231-83ae-4b43-852a-5bacdb7558b6"
  #skip_provider_registration = true
  resource_provider_registrations = "none"
  location = "eastus"


}
