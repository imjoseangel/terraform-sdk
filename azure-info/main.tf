provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you are using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
}

data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "current" {
  name = "cloud-shell-storage-westeurope"
}
