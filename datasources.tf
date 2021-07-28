data "aws_ami" "vanilla-ami" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }
}

data "aws_vpc" "active_vpc" {
  state = "available"

  tags = {
    Name = "core"
  }
}

data "aws_subnet" "subnet" {
  id = "subnet-56650d1f"
}
