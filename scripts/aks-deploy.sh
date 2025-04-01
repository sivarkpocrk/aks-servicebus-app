#!/bin/bash
AKS_CLUSTER="MyAKSCluster"
RESOURCE_GROUP="MyResourceGroup"
ACR_NAME="myregistry"
NAMESPACE="transaction-namespace"

az aks create --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER --node-count 3 --enable-addons monitoring --generate-ssh-keys
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER
kubectl create namespace $NAMESPACE
kubectl create secret generic servicebus-secrets --from-literal=primary-connection="<primary_connection_string>" --from-literal=secondary-connection="<secondary_connection_string>" -n $NAMESPACE
kubectl apply -f k8s/deployment.yaml -n $NAMESPACE
echo "Application deployed successfully to AKS."
