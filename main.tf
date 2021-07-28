module "compute-example" {
  source     = "./module-ec2-instance"
  env        = var.env
  node_count = "1"

}
