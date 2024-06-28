#!/usr/bin/env bash

set -Eeuo pipefail

CurrentFileName=$(basename "$0")
echo "Execute $CurrentFileName - Start------------------------------------------"

## Create Azure Credentials
REPO_NAME=$(basename `git rev-parse --show-toplevel`)
SERVICE_PRINCIPAL_NAME_WLS_AKS="sp-${REPO_NAME}-wls-aks-$(date +%s)"
echo "Creating Azure Service Principal with name: $SERVICE_PRINCIPAL_NAME_WLS_AKS"
SUBSCRIPTION_ID=$(az account show --query id -o tsv| tr -d '\r\n')
echo "SUBSCRIPTION_ID="$SUBSCRIPTION_ID

AZURE_CREDENTIALS=$(az ad sp create-for-rbac --name ${SERVICE_PRINCIPAL_NAME_WLS_AKS} --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}" --sdk-auth --only-show-errors)
SP_ID=$( az ad sp list --display-name $SERVICE_PRINCIPAL_NAME_WLS_AKS --query \[0\].id -o tsv | tr -d '\r\n')
az role assignment create --assignee ${SP_ID} --scope="/subscriptions/${SUBSCRIPTION_ID}" --role "User Access Administrator"

## Set the Azure Credentials as a secret in the repository
gh secret set "AZURE_CREDENTIALS" -b"${AZURE_CREDENTIALS}"
gh variable set "SERVICE_PRINCIPAL_NAME_WLS_AKS" -b"${SERVICE_PRINCIPAL_NAME_WLS_AKS}"

echo "Execute $CurrentFileName - End--------------------------------------------"
