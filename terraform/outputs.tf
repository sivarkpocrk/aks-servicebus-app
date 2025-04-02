# Display Primary Namespace ID
output "primary_namespace_id" {
  description = "ID of the primary Service Bus namespace"
  value       = azurerm_servicebus_namespace.primary.id
}

# Display Secondary Namespace ID
output "secondary_namespace_id" {
  description = "ID of the secondary Service Bus namespace"
  value       = azurerm_servicebus_namespace.secondary.id
}

# Display Service Bus Queue ID
output "servicebus_queue_id" {
  description = "ID of the Service Bus queue"
  value       = azurerm_servicebus_queue.transaction.id
}

# Display Resource Group
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.example.name
}
