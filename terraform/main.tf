# Unified main.tf

terraform {
  backend "azurerm" {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = var.backend_key
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
  client_id                  = var.client_id
  client_secret              = var.client_secret
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true
}

# Resource Group (already exists, so use import if not in state)
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.primary_location
  tags     = var.tags
}

# Storage Account for Terraform State
resource "azurerm_storage_account" "tfstate" {
  resource_group_name      = var.resource_group_name
  name                     = var.backend_storage_account_name
  location                 = var.primary_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Storage Container for Terraform State
resource "azurerm_storage_container" "tfstate" {
  name                  = var.backend_container_name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# Primary Service Bus Namespace
resource "azurerm_servicebus_namespace" "primary" {
  name                = var.primary_namespace
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.example.name
  # sku                 = "Standard"
  sku                 = "Premium"       # Change to Premium
  capacity            = 1   # Change to 1, 2, 4, 8, or 16
}

# Secondary Service Bus Namespace
resource "azurerm_servicebus_namespace" "secondary" {
  name                = var.secondary_namespace
  location            = var.secondary_location
  resource_group_name = azurerm_resource_group.example.name
  # sku                 = "Standard"
  sku                 = "Premium"       # Change to Premium
  capacity            = 1   # Change to 1, 2, 4, 8, or 16
}

# Service Bus Queue
resource "azurerm_servicebus_queue" "transaction" {
  name         = var.queue_name
  namespace_id = azurerm_servicebus_namespace.primary.id
}

# Geo-Disaster Recovery Alias
resource "azurerm_servicebus_namespace_disaster_recovery_config" "geo_dr" {
  name                 = "TransactionAlias"
  primary_namespace_id = azurerm_servicebus_namespace.primary.id
  partner_namespace_id = azurerm_servicebus_namespace.secondary.id
}
