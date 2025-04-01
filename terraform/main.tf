terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.74.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "MyResourceGroup"
  location = "East US"
}

resource "azurerm_servicebus_namespace" "primary" {
  name                = "PrimaryEISNamespace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
}

resource "azurerm_servicebus_queue" "transaction" {
  name                = "TransactionQueue"
  namespace_id        = azurerm_servicebus_namespace.primary.id
}

resource "azurerm_servicebus_namespace" "secondary" {
  name                = "SecondaryEISNamespace"
  location            = "West US"
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
}

output "primary_namespace_id" {
  value = azurerm_servicebus_namespace.primary.id
}

output "secondary_namespace_id" {
  value = azurerm_servicebus_namespace.secondary.id
}
