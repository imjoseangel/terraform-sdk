
data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "current" {
  name = "cloud-shell-storage-westeurope"
}
