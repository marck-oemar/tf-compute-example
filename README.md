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
'create_resource.sh' will generate a resource id, create a new workspace and terraform apply. 
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
'delete_resource.sh <resource id>' will delete the stack based on resource id. 
It will also delete the terraform workspace.

## CRUD operations with Flask API
As a concept, we can expose a simple REST API with resources and methods.
The Flask API can be found in ```./api```
The API can be containerized and executed as follows:

```
docker run \
-e PYTHONUNBUFFERED=1 \ # make sure python output is realtime streamed to docker console
-e TF_CWD=../tf \ # the directory of the Terraform config 
-v $(pwd)/tf:/tf \ # mount of the directory of the Terraform config
-v $(pwd)/module-ec2-instance:/module-ec2-instance \ # mount of the directory of the Terraform module
-v /Users/marck/.aws/credentials:/root/.aws/credentials \ # aws credentials
-p 8080:8080 tfcomputeexample:latest 
```

### REST API
The API is merely a concept:
- the requests are synchronize. Refactor to asynchronize shouldn't be much work
- The resource names are according to the REST API Guidelines
- CRUD REST HTTP operations are implemented, instead of misusing resources names for operations.
- The return object of a request is a string. TODO: return proper json object.


The API structure for now is simply:

```
/api/ec2instance POST
/api/ec2instance/<id> DELETE
```

#### Explore the API Documentation with Swagger UI
The best way to build against an API is by exploring it. The API has Swagger UI enabled. 
Browser to http://0.0.0.0:8080/swagger for the API documentation.

Example usage:

```
curl http://0.0.0.0:8080/api/ec2instance -X POST
curl http://0.0.0.0:8080/api/ec2resource/3fvvse -X DELETE
```

#### Workload management
- Every operation forks a subprocess. This is not production grade!
- Improvement: create a backend microservice that is solely responsible for executing terraform and is scalable.
- Message queuing could be helpful.
