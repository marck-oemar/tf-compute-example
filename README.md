# Terraform Compute provision Example 
This repo is an example on how to manipulate infrastructure resources managed by Terrafor, from a CRUD perspective, specifically Create and Destroy. 
This in itself is a challenge since Terraform is declarative.

The Terraform config is a simple AWS EC2 stack, with a S3 remote state backend.

## Multiple instances of a single Terraform config
In order to manage multiple instances of a single Terraform config, we can utilize Terraform workspaces, where every workspace represents a unique state(file).
This allows us to execute concurrent operations against a Terraform config, since every operation should relate to a unique workspace.

## CRUD operations

### Create
'create_resource.sh' will generate a resource id, create a new workspace and terraform apply. 
If the workspace already exists and contains resources, it will fail.
that way we are always creating unique objects/stacks.

### Delete
'delete_resource.sh <resource id>' will delete the stack based on resource id. 
It will also delete the terraform workspace.

