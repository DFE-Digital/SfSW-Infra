#!/bin/bash

export TF_VAR_subscription_id=$(az account show --query id --output tsv)

az ad sp create-for-rbac --name <NAME> --role Contributor --scopes /subscriptions/$TF_VAR_subscription_id


# Add role assignment to the SP
az role assignment create --role --assignee "<your-client-id-or-object-id>" "Storage Blob Data Contributor" --scope "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Storage/storageAccounts/<storage-account>"



# create basic SP
# az ad app create --display-name "name"

# show an SP
# az ad sp show --id <app-id>

# delete an SP
# az ad sp delete --id <app-id>

