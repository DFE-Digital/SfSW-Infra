#!/bin/bash

terraform init

export TF_VAR_subscription_id=$(az account show --query id --output tsv)

terraform plan \
    -var "subscription_id=$TF_VAR_subscription_id" \
    # -var-file="terraform.production.tfvars"
