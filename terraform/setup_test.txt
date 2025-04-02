terraform {
  backend "azurerm" {
    resource_group_name  = "MyResourceGroup"
    storage_account_name = "terraformstatestorage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.74.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Create Primary Service Bus Namespace
resource "azurerm_servicebus_namespace" "primary" {
  name                = var.primary_namespace
  location            = var.primary_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}

# Create Secondary Service Bus Namespace
resource "azurerm_servicebus_namespace" "secondary" {
  name                = var.secondary_namespace
  location            = var.secondary_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}

# Create Service Bus Queue in Primary Namespace
resource "azurerm_servicebus_queue" "transaction" {
  name                = var.queue_name
  namespace_id        = azurerm_servicebus_namespace.primary.id
}

# Geo Disaster Recovery Alias
resource "azurerm_servicebus_georecovery_alias" "geo_dr" {
  name                     = "TransactionAlias"
  resource_group_name      = var.resource_group_name
  namespace_name           = azurerm_servicebus_namespace.primary.name
  partner_namespace_id     = azurerm_servicebus_namespace.secondary.id
  requires_manual_failover = true
}
