#!/bin/bash

if [ -z "$1" ] ; then echo "no resource id given" ; exit 1 ; fi 
RESOURCE_ID="$1"
TERRAFORM_WORKSPACE=${RESOURCE_ID}
TFENV=${RESOURCE_ID}

terraform init

if [[ $(terraform workspace list | grep "\s${TERRAFORM_WORKSPACE}$") ]]; then
  echo "Selecting the workspace..."
  terraform workspace select ${TERRAFORM_WORKSPACE}
else
  echo "Workspace based on stack id $1 does not exist, cannot delete stack"
  exit 1
fi

TF_VAR_env="${TFENV}" TF_VAR_node_count="1" terraform destroy -auto-approve
terraform workspace select default
terraform workspace delete ${TERRAFORM_WORKSPACE}
