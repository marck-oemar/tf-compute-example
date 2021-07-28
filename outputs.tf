
output "resource_id" {
  value = var.env
}

output "private_ips" {
  value = aws_instance.testvm.*.private_ip
}
