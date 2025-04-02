# Unified main.tf

terraform {
  backend "azurerm" {
    resource_group_name  = "MyResourceGroup"
    storage_account_name = "akssiva"
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

  # Use environment variables for authentication
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Resource Group (already exists, so use import if not in state)
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.primary_location
  tags     = var.tags
}

# Primary Service Bus Namespace
resource "azurerm_servicebus_namespace" "primary" {
  name                = var.primary_namespace
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
}

# Secondary Service Bus Namespace
resource "azurerm_servicebus_namespace" "secondary" {
  name                = var.secondary_namespace
  location            = var.secondary_location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
}

# Service Bus Queue
resource "azurerm_servicebus_queue" "transaction" {
  name         = var.queue_name
  namespace_id = azurerm_servicebus_namespace.primary.id
}

# Geo-Disaster Recovery Alias
resource "azurerm_servicebus_namespace_disaster_recovery_config" "geo_dr" {
  name                     = "TransactionAlias"
  primary_namespace_id     = azurerm_servicebus_namespace.primary.id
  partner_namespace_id     = azurerm_servicebus_namespace.secondary.id
}
