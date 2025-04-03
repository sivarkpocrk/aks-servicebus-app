#!/bin/bash
RESOURCE_GROUP="MyResourceGroup"
NAMESPACE_PRIMARY="PrimaryEISNamespace"
NAMESPACE_SECONDARY="SecondaryEISNamespace"
ALIAS_NAME="TransactionAlias"

# Set Geo-Disaster Recovery alias
az servicebus georecovery-alias set \
  --resource-group $RESOURCE_GROUP \
  --namespace-name $NAMESPACE_PRIMARY \
  --alias $ALIAS_NAME \
  --partner-namespace $NAMESPACE_SECONDARY

echo "Geo-Disaster Recovery alias configured successfully."
