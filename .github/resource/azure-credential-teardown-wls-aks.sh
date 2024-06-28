#!/usr/bin/env bash

set -Eeuo pipefail

CurrentFileName=$(basename "$0")
echo "Execute $CurrentFileName - Start------------------------------------------"

gh secret delete "AZURE_CREDENTIALS"
SERVICE_PRINCIPAL_NAME_WLS_AKS=$(gh variable get "SERVICE_PRINCIPAL_NAME_WLS_AKS")
az ad app delete --id $(az ad sp list --display-name "$SERVICE_PRINCIPAL_NAME_WLS_AKS" --query '[].appId' -o tsv| tr -d '\r\n')
gh variable delete "SERVICE_PRINCIPAL_NAME_WLS_AKS"

echo "Execute $CurrentFileName - End--------------------------------------------"
