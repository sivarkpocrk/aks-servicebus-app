# Resource Group Name
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "MyResourceGroup"
}

# Primary Namespace
variable "primary_namespace" {
  description = "Name of the primary Service Bus namespace"
  type        = string
  default     = "PrimaryEISNamespace"
}

# Secondary Namespace
variable "secondary_namespace" {
  description = "Name of the secondary Service Bus namespace"
  type        = string
  default     = "SecondaryEISNamespace"
}

# Location for Primary Namespace
variable "primary_location" {
  description = "Azure location for the primary namespace"
  type        = string
  default     = "East US"
}

# Location for Secondary Namespace
variable "secondary_location" {
  description = "Azure location for the secondary namespace"
  type        = string
  default     = "West US"
}

# Queue Name
variable "queue_name" {
  description = "Name of the Service Bus queue"
  type        = string
  default     = "TransactionQueue"
}

# Azure Subscription ID
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

# Tags for resources
variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default = {
    environment = "dev"
    owner       = "aks-servicebus-app"
  }
}

variable "client_id" {
  description = "Azure Service Principal Client ID"
}

variable "client_secret" {
  description = "Azure Service Principal Client Secret"
}

variable "tenant_id" {
  description = "Azure Tenant ID"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
}

