#!/bin/bash
RESOURCE_GROUP="MyResourceGroup"
LOCATION_PRIMARY="eastus"
LOCATION_SECONDARY="westus"
NAMESPACE_PRIMARY="PrimaryEISNamespace"
NAMESPACE_SECONDARY="SecondaryEISNamespace"
QUEUE_NAME="TransactionQueue"

az group create --name $RESOURCE_GROUP --location $LOCATION_PRIMARY

az servicebus namespace create --name $NAMESPACE_PRIMARY --resource-group $RESOURCE_GROUP --location $LOCATION_PRIMARY --sku Standard
az servicebus namespace create --name $NAMESPACE_SECONDARY --resource-group $RESOURCE_GROUP --location $LOCATION_SECONDARY --sku Standard
az servicebus queue create --resource-group $RESOURCE_GROUP --namespace-name $NAMESPACE_PRIMARY --name $QUEUE_NAME
echo "Service Bus namespaces and queue created successfully."
