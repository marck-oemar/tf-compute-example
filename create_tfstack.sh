#!/bin/sh
# NonZero exit error messages:
#  - error:ExistingWorkspaceContainsResources

set -x 

echo "generating random resource id"
RESOURCE_ID=$(tr -dc a-z0-9 </dev/urandom | head -c 6)
echo "resource id: ${RESOURCE_ID}"

TERRAFORM_WORKSPACE=${RESOURCE_ID}
TFENV=${RESOURCE_ID}

# allow for concurrent tf run with temp directory
echo "create temp. working directory, copy current working directory and traverse to temp. working directory"
CWD=$(pwd)
TMP_CWD=$(mktemp -d "${TMPDIR:-/tmp}/cwd-XXXXXXXXXX")
cp -r . ${TMP_CWD}
cd ${TMP_CWD}/tf

terraform init

if [ $(terraform workspace list | grep "\s${TERRAFORM_WORKSPACE}$") ]; then
  echo "Selecting the workspace..."
  terraform workspace select ${TERRAFORM_WORKSPACE}
  if ! [ -z $(terraform state list) ] ; then 
    echo "error:ExistingWorkspaceContainsResources"
    echo "this terraform workspace already contains infra resources. Cannot create already existing resource"
    exit 1
  fi
else
  echo "Creating new workspace..."
  terraform workspace new ${TERRAFORM_WORKSPACE}
fi

TF_VAR_env="${TFENV}" terraform apply -auto-approve

# allow for concurrent tf run with temp directory
echo "traverse to starting working directory and delete temp. working directory"
cd ${CWD}
rm -rf ${TMP_CWD}