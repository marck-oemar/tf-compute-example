output "resource_id" {
  value = module.compute-example.resource_id
}

output "private_ips" {
  value = module.compute-example.*.private_ips
}
