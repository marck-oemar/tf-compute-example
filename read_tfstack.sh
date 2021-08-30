#!/bin/sh
set -x 
# NonZero exit error messages:
#  - error:IdNotSpecified
#  - error:WorkspaceNotExist

if [ -z "$1" ] ; then
  echo "error:IdNotSpecified"
  echo "no resource id given"
  exit 1
fi 
RESOURCE_ID="$1"
TERRAFORM_WORKSPACE=${RESOURCE_ID}
TFENV=${RESOURCE_ID}

# allow for concurrent tf run with temp directory
echo "create temp. working directory, copy current working directory and traverse to temp. working directory"
CWD=$(pwd)
TMP_CWD=$(mktemp -d "${TMPDIR:-/tmp}/cwd-XXXXXXXXXX")
cp -r . ${TMP_CWD}
cd ${TMP_CWD}/tf

terraform init

if [ "$(terraform workspace list | grep "\s${TERRAFORM_WORKSPACE}$")" ]; then
  echo "Selecting the workspace..."
  terraform workspace select ${TERRAFORM_WORKSPACE}
else
  echo "error:WorkspaceNotExist"
  echo "workspace based on stack id $1 does not exist, cannot continue"
  exit 1
fi

list=$(terraform state list)
for i in ${list}; do
  echo ""
  echo "=========== $i ============"
  terraform state show $i
done
terraform workspace select default

# allow for concurrent tf run with temp directory
echo "traverse to starting working directory and delete temp. working directory"
cd ${CWD}
rm -rf ${TMP_CWD}