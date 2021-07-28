#!/bin/bash

echo "generating random resource id"
RESOURCE_ID=$(tr -dc a-z0-9 </dev/urandom | head -c 6)
echo "resource id: ${RESOURCE_ID}"

TERRAFORM_WORKSPACE=${RESOURCE_ID}
TFENV=${RESOURCE_ID}

terraform init

if [[ $(terraform workspace list | grep "\s${TERRAFORM_WORKSPACE}$") ]]; then
  echo "Selecting the workspace..."
  terraform workspace select ${TERRAFORM_WORKSPACE}
  if ! [ -z $(terraform state list) ] ; then echo "this terraform workspace already contains infra resources. Cannot create already existing resource" ; exit 1 ; fi
else
  echo "Creating new workspace..."
  terraform workspace new ${TERRAFORM_WORKSPACE}
fi

TF_VAR_env="${TFENV}" TF_VAR_node_count="1" terraform apply -auto-approve