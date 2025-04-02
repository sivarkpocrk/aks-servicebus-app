#!/bin/bash

# Check if the required environment variables are set

echo "CLIENT_ID: $CLIENT_ID"
echo "TENANT_ID: $TENANT_ID"


if [ -z "$CLIENT_ID" ] || [ -z "$CLIENT_SECRET" ] || [ -z "$TENANT_ID" ] || [ -z "$SUBSCRIPTION_ID" ]; then
    echo "Error: One or more required environment variables are missing."
    echo "Please set CLIENT_ID, CLIENT_SECRET, TENANT_ID, and SUBSCRIPTION_ID."
    exit 1
fi

# Log in to Azure using the Service Principal
echo "Logging into Azure..."
az login --service-principal \
    --username "$CLIENT_ID" \
    --password "$CLIENT_SECRET" \
    --tenant "$TENANT_ID"

# Set the subscription ID
az account set --subscription "$SUBSCRIPTION_ID"

# Execute any given Terraform command
exec terraform "$@"
