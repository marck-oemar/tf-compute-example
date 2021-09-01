# Terraform Compute provision Example 
This repo is an example on how to manipulate infrastructure resources managed by Terraform, from a CRUD perspective, specifically Create and Destroy. 
This in itself is a challenge since Terraform is declarative.

The Terraform config in ```./tf``` sources a Terraform module in ```./module-ec2-instance``` which is a simple AWS EC2 stack.
Also a S3 remote state backend is configured.

## Multiple instances of a single Terraform config
In order to manage multiple instances of a single Terraform config, we can utilize Terraform workspaces (https://www.terraform.io/docs/language/state/workspaces.html), where every workspace represents a unique state(file).
This allows us to execute concurrent operations against a Terraform config, since every operation should relate to a unique workspace.

## CRUD operations via shell script

### Create
'create_tfstack.sh' will generate a resource id, create a new workspace and terraform apply. 
If the workspace already exists and contains resources, it will fail.
that way we are always creating unique objects/stacks.

Example result:

```
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

private_ips = [
  [
    "a.b.c.d",
  ],
]
resource_id = "ecwz8j"
```

### Delete
'delete_tfstack.sh <resource id>' will delete the stack based on resource id. 
It will also delete the terraform workspace.
