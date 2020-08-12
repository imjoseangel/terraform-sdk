output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

output "id" {
  value = data.azurerm_resource_group.current.id
}
