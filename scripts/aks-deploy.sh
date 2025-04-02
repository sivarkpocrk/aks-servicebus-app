#!/bin/bash

# Use environment variables set in the GitHub workflow
AKS_CLUSTER="${AKS_CLUSTER_NAME:-AKSSivaCluster}"
RESOURCE_GROUP="${RESOURCE_GROUP:-MyResourceGroup}"
ACR_NAME="${ACR_NAME:-akssivarg01}"
NAMESPACE="${NAMESPACE:-transaction-namespace}"

# Get AKS credentials to manage the cluster
echo "Retrieving AKS credentials..."
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER

# Create the namespace if it does not exist
if ! kubectl get namespace $NAMESPACE &> /dev/null; then
  echo "Creating namespace: $NAMESPACE"
  kubectl create namespace $NAMESPACE
else
  echo "Namespace $NAMESPACE already exists."
fi

# Create or update the Kubernetes secret for Service Bus connection strings
echo "Creating or updating secrets in namespace: $NAMESPACE"
kubectl create secret generic servicebus-secrets \
  --from-literal=primary-connection="<primary_connection_string>" \
  --from-literal=secondary-connection="<secondary_connection_string>" \
  -n $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Apply the Kubernetes deployment and service configurations
echo "Deploying application to AKS..."
kubectl apply -f k8s/deployment.yaml -n $NAMESPACE
echo "Application deployed successfully to AKS."
