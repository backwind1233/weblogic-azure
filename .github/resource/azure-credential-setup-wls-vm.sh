#!/usr/bin/env bash

set -Eeuo pipefail

$CURRENT_FILE_NAME=$(basename "$0")
echo "Execute $$CURRENT_FILE_NAME - Start------------------------------------------"

## Create Azure Credentials
REPO_NAME=$(basename `git rev-parse --show-toplevel`)

SERVICE_PRINCIPAL_NAME_WLS_VM="sp-${REPO_NAME}-wls-vm-$(date +%s)"
echo "Creating Azure Service Principal with name: $SERVICE_PRINCIPAL_NAME_WLS_VM"
SUBSCRIPTION_ID=$(az account show --query id -o tsv| tr -d '\r\n')
echo "SUBSCRIPTION_ID="$SUBSCRIPTION_ID
AZURE_CREDENTIALS=$(az ad sp create-for-rbac --name ${SERVICE_PRINCIPAL_NAME_WLS_VM} --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}" --sdk-auth --only-show-errors)

## Set the Azure Credentials as a secret in the repository
gh secret set "AZURE_CREDENTIALS" -b"${AZURE_CREDENTIALS}"
gh variable set "SERVICE_PRINCIPAL_NAME_WLS_VM" -b"${SERVICE_PRINCIPAL_NAME_WLS_VM}"

echo "Execute $$CURRENT_FILE_NAME - End--------------------------------------------"
