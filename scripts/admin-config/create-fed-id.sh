#!/bin/bash

APP_ID="<APP ID>"

PARAMS=$(cat <<EOF
{
    "name": "<SERVICE-PRINCIPAL-NAME>",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:<ORG-NAME>/<REPO-NAME>:ref:refs/heads/main:environment:<ENV>",
    "description": "<DESCRIPTION>",
    "audiences": [
        "api://AzureADTokenExchange"
    ]
}
EOF
)

az ad app federated-credential create --id "$APP_ID" --parameters "$PARAMS"

if [ $? -ne 0 ]; then
    echo "Failed to create federated credential."
    exit 1
fi
