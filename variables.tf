variable "region" {
  description = "AWS Region to operate in"
  default     = "eu-west-1"
}

variable "owner" {
  description = "Owner of this AWS account"
  type        = string
  default     = "262665658232"
}

variable "env" {
  description = "Name of the space instance. Often equal to branch"
  type        = string
}

variable "instance-type" {
  description = "runner-Instance type"
  type        = string
  default     = "t2.medium"
}

variable "volume_size" {
  description = "size of root volume"
  default     = "20"
}

variable "node_count" {
  description = "Number of the nodes."
}
