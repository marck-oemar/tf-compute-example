terraform {
  backend "s3" {
    bucket               = "cel-inception-tfstate"
    key                  = "testvm.tfstate"
    region               = "eu-west-1"
    encrypt              = false
    workspace_key_prefix = "testvm"
  }
}
