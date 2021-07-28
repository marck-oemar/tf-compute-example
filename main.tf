##################

resource "aws_security_group" "testvm" {
  name_prefix = "tf-testvm-${var.env}-"
  description = "testvm"
  vpc_id      = data.aws_vpc.active_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "tf-testvm-${var.env}"
    terraform = "true"
  }
}

resource "aws_instance" "testvm" {
  count                       = var.node_count
  ami                         = data.aws_ami.vanilla-ami.id
  instance_type               = var.instance-type
  iam_instance_profile        = aws_iam_role.testvm.id
  subnet_id                   = data.aws_subnet.subnet.id
  associate_public_ip_address = true
  key_name                    = "marckoemar"

  vpc_security_group_ids = [
    "${aws_security_group.testvm.id}",
  ]

  tags = {
    Name      = "tf-testvm-${var.env}"
    terraform = "true"
  }
}
